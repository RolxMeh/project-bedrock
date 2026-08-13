data "archive_file" "asset_processor" {
  type        = "zip"
  source_file = "${path.module}/lambda/asset_processor.py"
  output_path = "${path.module}/lambda/asset_processor.zip"
}

resource "aws_s3_bucket" "assets" {
  bucket = local.assets_bucket_name
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_role" "asset_processor" {
  name = "bedrock-asset-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "asset_processor" {
  name = "bedrock-asset-processor-policy"
  role = aws_iam_role.asset_processor.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/bedrock-asset-processor:*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

resource "aws_lambda_function" "asset_processor" {
  function_name = "bedrock-asset-processor"

  role = aws_iam_role.asset_processor.arn

  filename         = data.archive_file.asset_processor.output_path
  source_code_hash = data.archive_file.asset_processor.output_base64sha256

  runtime = "python3.12"
  handler = "asset_processor.lambda_handler"

  timeout     = 30
  memory_size = 128
}

resource "aws_cloudwatch_log_group" "asset_processor" {
  name              = "/aws/lambda/bedrock-asset-processor"
  retention_in_days = 7
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.assets.arn
}

resource "aws_s3_bucket_notification" "assets" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}
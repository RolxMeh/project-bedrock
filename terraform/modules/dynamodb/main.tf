resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  dynamic "attribute" {
    for_each = var.gsi_hash_key != null ? [var.gsi_hash_key] : []

    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi_name != null ? [var.gsi_name] : []

    content {
      name            = global_secondary_index.value
      hash_key        = var.gsi_hash_key
      projection_type = "ALL"
    }
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name    = var.table_name
    Project = var.project_tag
  }
}
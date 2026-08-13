output "vpc_id" {
  description = "Project Bedrock VPC ID"
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "Project Bedrock EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Project Bedrock EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

output "assets_bucket_name" {
  description = "S3 bucket used for product assets"
  value       = aws_s3_bucket.assets.bucket
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}
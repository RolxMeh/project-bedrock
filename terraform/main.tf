data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "vpc" {
  source = "./modules/vpc"

  vpc_name           = local.vpc_name
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = var.availability_zones
  project_tag        = var.project_tag
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = local.cluster_name
  kubernetes_version = "1.31"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  aws_region = var.aws_region

  project_tag = var.project_tag

  node_instance_type = "t3.small"
  node_desired_size  = 2
  node_min_size      = 2
  node_max_size      = 2
}

module "rds" {
  source = "./modules/rds"

  identifier = "project-bedrock-postgres"

  db_name  = "retail"
  username = var.db_username
  password = var.db_password

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  eks_node_security_group_id = module.eks.cluster_security_group_id

  project_tag = var.project_tag
}

module "dynamodb_orders" {
  source = "./modules/dynamodb"

  table_name = "orders"
  hash_key   = "order_id"

  project_tag = var.project_tag
}

module "dynamodb_items" {
  source = "./modules/dynamodb"

  table_name = "Items"
  hash_key   = "id"

  gsi_name     = "idx_global_customerId"
  gsi_hash_key = "customerId"

  project_tag = var.project_tag
}

module "rds_mysql" {
  source = "./modules/rds-mysql"

  identifier = "project-bedrock-mysql"

  db_name  = "catalog"
  username = var.mysql_username
  password = var.mysql_password

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  eks_node_security_group_id = module.eks.cluster_security_group_id

  project_tag = var.project_tag
}
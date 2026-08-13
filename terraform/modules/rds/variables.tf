variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master database username"
  type        = string
}

variable "password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "eks_node_security_group_id" {
  description = "Security group ID used by EKS worker nodes"
  type        = string
}

variable "project_tag" {
  description = "Project tag"
  type        = string
}
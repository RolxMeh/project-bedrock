variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-east-1"
}

variable "project_tag" {
  description = "Project tag applied to all resources"
  type        = string
  default     = "tinyuka-2025-capstone"
}

variable "availability_zones" {
  description = "Availability zones for the VPC"
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "appadmin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "mysql_username" {
  description = "RDS MySQL master username"
  type        = string
  default     = "appadmin"
}

variable "mysql_password" {
  description = "RDS MySQL master password"
  type        = string
  sensitive   = true
}

variable "budget_alert_email" {
  description = "Email address for AWS Budget alerts"
  type        = string
  sensitive   = true
}
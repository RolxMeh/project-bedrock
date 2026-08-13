variable "table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "hash_key" {
  description = "DynamoDB partition key"
  type        = string
}

variable "gsi_name" {
  description = "Optional global secondary index name"
  type        = string
  default     = null
}

variable "gsi_hash_key" {
  description = "Optional global secondary index partition key"
  type        = string
  default     = null
}

variable "project_tag" {
  description = "Project tag"
  type        = string
}
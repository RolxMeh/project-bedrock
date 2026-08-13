variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "project_tag" {
  description = "Project tag"
  type        = string
}
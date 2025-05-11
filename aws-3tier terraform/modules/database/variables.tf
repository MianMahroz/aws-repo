variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "App Tier Security Group ID"
}
variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for instances"
  default     = "ami-0f88e80871fd81e91"
}

variable "key_pair" {
  description = "Key pair name"
  default     = "3tier-app-key"
}
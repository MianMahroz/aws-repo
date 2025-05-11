provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "./modules/networking"
  
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "bastion" {
  source = "./modules/bastion"
  
  vpc_id          = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  ami_id          = "ami-0f88e80871fd81e91" # Update with your AMI
  key_pair        = "3tier-app-key"         # Update with your key pair
}

module "compute" {
  source = "./modules/compute"
  
  vpc_id                   = module.networking.vpc_id
  public_subnet_ids        = module.networking.public_subnet_ids
  private_subnet_ids       = module.networking.private_subnet_ids
  ami_id                   = "ami-0f88e80871fd81e91" # Update with your AMI
  key_pair                 = "3tier-app-key"         # Update with your key pair
  alb_security_group_id    = module.networking.alb_security_group_id
  bastion_security_group_id = module.bastion.bastion_security_group_id
}

module "database" {
  source = "./modules/database"
  
  vpc_id              = module.networking.vpc_id
  private_subnet_ids  = module.networking.private_subnet_ids
  app_security_group_id = module.compute.app_security_group_id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion Host"
  value       = module.bastion.bastion_public_ip
}

output "presentation_alb_dns" {
  description = "DNS Name of Presentation ALB"
  value       = module.compute.presentation_alb_dns
}

output "application_alb_dns" {
  description = "DNS Name of Application ALB"
  value       = module.compute.application_alb_dns
}
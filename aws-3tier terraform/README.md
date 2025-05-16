#### Modular Structure: 
The Terraform code is organized into logical modules (networking, compute, database, bastion) for better maintainability.

#### Dynamic Availability Zones: 
Uses data.aws_availability_zones to automatically fetch available AZs.

#### Count Parameters: 
Uses count to create multiple subnets, NAT gateways, etc., reducing repetitive code.

#### Latest Launch Template Version: 
Uses $Latest for launch template versions in ASGs.

#### Output Variables: 
Each module exposes relevant outputs for other modules to consume.

#### Variable Files: 
Each module has its own variables.tf for clear input requirements.

#### Simplified Security Groups: 
Combined ingress/egress rules where possible.

### To use this Terraform configuration:

- Run terraform init to initialize the modules

- Run terraform plan to review changes

- Run terraform apply to create the infrastructure

### Note: 
You may need to adjust the AMI ID and key pair name based on your AWS region and existing resources.

![Untitled](https://github.com/user-attachments/assets/003cdb91-952d-41b3-858c-dfcdd93d4b75)


![6](https://github.com/user-attachments/assets/9f9784ab-4697-46c3-a91c-53a0bc17b43d)

![5](https://github.com/user-attachments/assets/d3c87ef5-6cdb-41d4-9ee6-ca96c90c92b4)

![4](https://github.com/user-attachments/assets/c12824f5-4c43-426b-ba7b-96a874c4a4d8)

![3](https://github.com/user-attachments/assets/7447d305-fc70-4036-82e9-1a094636ac63)

![2](https://github.com/user-attachments/assets/f346a6eb-5b9e-4bc3-bd86-481c9e738225)








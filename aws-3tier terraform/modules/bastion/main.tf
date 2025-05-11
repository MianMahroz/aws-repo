resource "aws_security_group" "bastion" {
  name        = "BastionSG"
  description = "Allow SSH from your IP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BastionSG"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_pair
  subnet_id     = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  
  tags = {
    Name = "BastionHost"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
  
  tags = {
    Name = "BastionEIP"
  }
}
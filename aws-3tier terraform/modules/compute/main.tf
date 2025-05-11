resource "aws_security_group" "presentation" {
  name        = "PresentationInstanceSG"
  description = "Allow HTTP and outbound internet access"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PresentationInstanceSG"
  }
}

resource "aws_security_group" "app" {
  name        = "AppTierSG"
  description = "Allow HTTP from ALB and SSH from Bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AppTierSG"
  }
}

resource "aws_launch_template" "presentation" {
  name_prefix   = "PresentationLT"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_pair

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.presentation.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    exec > /tmp/userdata.log 2>&1
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    yum update -y
    yum install -y httpd
    if [ $? -eq 0 ]; then
      echo "httpd installation successful" >> /tmp/userdata.log
      systemctl start httpd
      systemctl enable httpd
      echo "httpd started and enabled" >> /tmp/userdata.log
      echo "Presentation layer running" > /var/www/html/index.html
    else
      echo "httpd installation FAILED" >> /tmp/userdata.log
      ping -c 3 google.com >> /tmp/userdata.log
      curl -I http://google.com >> /tmp/userdata.log
      exit 1
    fi
  EOF
  )
}

resource "aws_launch_template" "application" {
  name_prefix   = "ApplicationLT"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_pair

  network_interfaces {
    security_groups = [aws_security_group.app.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    exec > /tmp/userdata.log 2>&1
    yum update -y
    yum install -y httpd
    if [ $? -eq 0 ]; then
      echo "httpd installation successful" >> /tmp/userdata.log
      systemctl start httpd
      systemctl enable httpd
      echo "httpd started and enabled" >> /tmp/userdata.log
      echo "BE SERVER layer running" > /var/www/html/index.html
    else
      echo "httpd installation FAILED" >> /tmp/userdata.log
      exit 1
    fi
  EOF
  )
}

resource "aws_lb" "presentation" {
  name               = "PresentationALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "PresentationALB"
  }
}

resource "aws_lb" "application" {
  name               = "ApplicationALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "ApplicationALB"
  }
}

resource "aws_lb_target_group" "presentation" {
  name     = "PresentationTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "application" {
  name     = "ApplicationTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "presentation" {
  load_balancer_arn = aws_lb.presentation.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.presentation.arn
  }
}

resource "aws_lb_listener" "application" {
  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }
}

resource "aws_autoscaling_group" "presentation" {
  name_prefix          = "PresentationASG-"
  vpc_zone_identifier  = var.public_subnet_ids
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  launch_template {
    id      = aws_launch_template.presentation.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.presentation.arn]

  tag {
    key                 = "Name"
    value               = "PresentationInstance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "application" {
  name_prefix          = "ApplicationASG-"
  vpc_zone_identifier  = var.private_subnet_ids
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.application.arn]

  tag {
    key                 = "Name"
    value               = "ApplicationInstance"
    propagate_at_launch = true
  }
}
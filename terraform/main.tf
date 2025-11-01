# provider "aws" {
#   region = "ap-southeast-1"
# }

# # -------------------------------
# # 1️⃣ VPC
# # -------------------------------
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   tags = {
#     Name = "ci-vpc"
#   }
# }

# # -------------------------------
# # 2️⃣ Public & Private Subnets (2 AZs)
# # -------------------------------
# resource "aws_subnet" "public_a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "ap-southeast-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-a"
#   }
# }

# resource "aws_subnet" "public_b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "ap-southeast-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-b"
#   }
# }

# resource "aws_subnet" "private_a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "ap-southeast-1a"
#   tags = {
#     Name = "private-subnet-a"
#   }
# }

# resource "aws_subnet" "private_b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.4.0/24"
#   availability_zone = "ap-southeast-1b"
#   tags = {
#     Name = "private-subnet-b"
#   }
# }

# # -------------------------------
# # 3️⃣ Internet Gateway + Route tables
# # -------------------------------
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "vpc-igw"
#   }
# }

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "public-rt"
#   }
# }

# resource "aws_route_table_association" "public_a_assoc" {
#   subnet_id      = aws_subnet.public_a.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "public_b_assoc" {
#   subnet_id      = aws_subnet.public_b.id
#   route_table_id = aws_route_table.public_rt.id
# }

# # -------------------------------
# # 4️⃣ NAT Gateway cho private subnet ra Internet
# # -------------------------------
# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_a.id
#   tags = {
#     Name = "nat-gateway"
#   }
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw.id
#   }
#   tags = {
#     Name = "private-rt"
#   }
# }

# resource "aws_route_table_association" "private_a_assoc" {
#   subnet_id      = aws_subnet.private_a.id
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_route_table_association" "private_b_assoc" {
#   subnet_id      = aws_subnet.private_b.id
#   route_table_id = aws_route_table.private_rt.id
# }

# # -------------------------------
# # 5️⃣ Security Groups
# # -------------------------------
# resource "aws_security_group" "alb_sg" {
#   vpc_id = aws_vpc.main.id
#   name   = "alb-sg"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb-sg"
#   }
# }

# resource "aws_security_group" "ec2_sg" {
#   vpc_id = aws_vpc.main.id
#   name   = "ec2-sg"

#   ingress {
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ec2-sg"
#   }
# }

# # -------------------------------
# # 6️⃣ Launch Template + Auto Scaling Group
# # -------------------------------
# resource "aws_launch_template" "app_lt" {
#   name_prefix   = "app-template"
#   image_id      = "ami-0c55b159cbfafe1f0" # thay bằng AMI region bạn
#   instance_type = "t3.micro"
#   key_name      = "your-keypair-name"

#   user_data = base64encode(<<EOF
# #!/bin/bash
# sudo apt update -y
# sudo apt install -y docker.io
# sudo systemctl start docker
# sudo docker run -d -p 3000:3000 your-dockerhub-user/your-app:latest
# EOF
#   )

#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "app-instance"
#     }
#   }
# }

# resource "aws_autoscaling_group" "asg" {
#   name                      = "app-asg"
#   max_size                  = 2
#   min_size                  = 1
#   desired_capacity           = 1
#   vpc_zone_identifier       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
#   launch_template {
#     id      = aws_launch_template.app_lt.id
#     version = "$Latest"
#   }

#   target_group_arns = [aws_lb_target_group.app_tg.arn]

#   tag {
#     key                 = "Name"
#     value               = "app-asg-instance"
#     propagate_at_launch = true
#   }
# }

# # -------------------------------
# # 7️⃣ Application Load Balancer
# # -------------------------------
# resource "aws_lb" "app_alb" {
#   name               = "app-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

#   tags = {
#     Name = "app-alb"
#   }
# }

# resource "aws_lb_target_group" "app_tg" {
#   name     = "app-tg"
#   port     = 3000
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "app-tg"
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }

# output "alb_dns_name" {
#   value = aws_lb.app_alb.dns_name
# }

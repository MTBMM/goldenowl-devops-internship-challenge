variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "azs" {
  description = "Availability zones to use (at least 2)"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidrs" {
  description = "CIDRs for public subnets (list length == azs length)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  description = "CIDRs for private subnets (list length == azs length)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "your-keypair-name"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI id to use for EC2 instances (Ubuntu/Debian recommended)"
  type        = string
  default     = "ami-0123456789abcdef0" # <-- CHANGE THIS to a valid AMI in your region
}

variable "docker_image" {
  description = "Docker image (including repository) to run on EC2 e.g. username/repo:tag"
  type        = string
  default     = "yourdockeruser/kiencicd:latest"
}

variable "asg_min_size" {
  type    = number
  default = 1
}
variable "asg_max_size" {
  type    = number
  default = 2
}
variable "asg_desired" {
  type    = number
  default = 1
}

variable "health_check_path" {
  description = "ALB health check path"
  type        = string
  default     = "/"
}

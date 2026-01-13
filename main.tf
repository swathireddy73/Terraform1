############################
# LOCALS
############################
locals {
  env = terraform.workspace
}

############################
# MODULE – VPC (TASK 1)
############################
module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
  env    = local.env
}

############################
# DATA SOURCE – EXISTING AMI (TASK 4)
############################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

############################
# COUNT LOOP – EC2 INSTANCES (TASK 3)
############################
resource "aws_instance" "sp_ec2" {
  count         = 2
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "sp-${local.env}-ec2-${count.index}"
  }
}

############################
# FOR_EACH LOOP – S3 BUCKETS (TASK 3)
############################
resource "aws_s3_bucket" "sp_bucket" {
  for_each = toset(var.buckets)

  bucket = "sp-${local.env}-${each.value}"
}

############################
# IMPORT TARGET – SECURITY GROUP (TASK 2)
############################
resource "aws_security_group" "sp_sg" {
  name        = "sp-existing-sg"
  description = "Imported existing SG"
  vpc_id      = module.vpc.vpc_id
}


provider "aws" {
  region = var.region
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "ena-support"
    values = ["true"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
#Create a syslog server on the ec2 instance
resource "aws_instance" "syslog" {
  ami                  = data.aws_ami.ami.id
  instance_type        = "t3.micro"
  subnet_id            = var.private_subnet_ids[2]
  user_data            = file("./scripts/syslog-startup.sh")
  iam_instance_profile = var.iam_instance_profile

  vpc_security_group_ids = [var.syslog_sg_id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "syslog-server"
  }
}
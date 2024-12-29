variable "region" {
  description = "The region in which to create the network"
  type        = string
}

variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "vpc_id" {
  description = "The id for the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs for the private subnets"
  type        = list(string)
}
variable "iam_instance_profile" {
  description = "The IAM instance profile for the backend instances"
  type        = string
}
variable "syslog_sg_id" {
  description = "The security group ID for the syslog server"
  type        = string

}
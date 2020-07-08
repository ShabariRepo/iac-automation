//Global variables
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = "default"
}

variable "hosted_zone_id" {
  description = "Route53 zone id"
}

variable "bastion_key_name" {
  description = "Bastion KeyName"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"  
  default     = ["us-east-1a", "us-east-1b"] //, "us-east-1c"] //,us-east-1c,us-east-1d"]
}

// Default variables
variable "vpc_name" {
  description = "VPC name"
  default     = "devops-pipeline-automation1"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_count" {
  default     = 2
  description = "Number of public subnets"
}

variable "private_count" {
  default     = 2
  description = "Number of private subnets"
}

variable "bastion_instance_type" {
  description = "Bastion Instance type"
  default     = "t2.micro"
}

# author: Elmer Almeida
# date: dec 17 2021
# contains all the variable declarations to be used in main.tf

variable "vpc_address_space" {
  type        = list(string)
  description = "The VPC address space. (A, B)"
  default = [
    "A",
    "B"
  ]
}

variable "vpc_cidr_block" {
  type        = list(string)
  description = "VPC CIDR block"
  default = [
    "10.0.0.0/16",
    "192.168.0.0/16"
  ]
}

variable "public_cidr_block" {
  type        = string
  description = "Public CIDR block"
  default     = "0.0.0.0/0"
}


variable "public_subnet_01" {
  type        = list(string)
  description = "Public subnet 01 - CIDR blocks"
  default = [
    "10.0.1.0/24",
    "192.168.1.0/24",
  ]
}

variable "public_subnet_02" {
  type        = list(string)
  description = "Public subnet 02 - CIDR blocks"
  default = [
    "10.0.3.0/24",
    "192.168.3.0/24",
  ]
}

variable "private_subnet_01" {
  type        = list(string)
  description = "Private subnet 01 - CIDR blocks"
  default = [
    "10.0.2.0/24",
    "192.168.2.0/24"
  ]
}

variable "private_subnet_02" {
  type        = list(string)
  description = "Private subnet 02 - CIDR blocks"
  default = [
    "10.0.4.0/24",
    "192.168.4.0/24"
  ]
}

variable "availability_zones" {
  type        = list(string)
  description = "All availability zones"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
  ]
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_instance_ami" {
  type        = string
  description = "AMI ID for EC2 instance"
  default     = "ami-0ed9277fb7eb570c9"
}

variable "ec2_instance_key" {
  type        = string
  description = "EC2 instance key name (mac-mini-m1.pem)"
  default     = "mac-mini-m1"
}

variable "SG_ssh_web_data" {
  type        = list(string)
  description = "SSH & Web Security Group details"
  default = [
    "ssh_web_SG",
    "Allow SSh and HTTP security group rules"
  ]
}

variable "ports" {
  type        = list(number)
  description = "A list of all the ports to use"
  default = [
    22,
    80,
    0
  ]
}

variable "protocols" {
  type = list(string)
  # created to add flexibility for other protocol types such as UDP
  # attempt at flexible code design
  default = [
    "tcp",
    "-1"
  ]
}

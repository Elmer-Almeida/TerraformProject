# author: Elmer Almeida
# date: dec 17 2021
# contains the implementations to create resources for AWS

locals {
  webserver_bootstrap = templatefile("${path.module}/templates/webserver-bootstrap.sh", {})
}

# Create VPCs
resource "aws_vpc" "VPC" {
  count                = length(var.vpc_address_space)
  cidr_block           = var.vpc_cidr_block[count.index]
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "VPC-${var.vpc_address_space[count.index]}"
  }
}

# Create Internet Gateways
resource "aws_internet_gateway" "IGW" {
  count  = length(var.vpc_address_space)
  vpc_id = aws_vpc.VPC[count.index].id
  tags = {
    Name = "IGW-${var.vpc_address_space[count.index]}"
  }
}

# Create public route table
resource "aws_route_table" "publicRT" {
  count  = length(var.vpc_address_space)
  vpc_id = aws_vpc.VPC[count.index].id
  route {
    cidr_block = var.public_cidr_block
    gateway_id = aws_internet_gateway.IGW[count.index].id
  }
  tags = {
    Name = "publicRT-${var.vpc_address_space[count.index]}"
  }
}


# Create a public subnet
# This will be for subnet-public-01 for VPC-A and VPC-B
resource "aws_subnet" "publicSN-01" {
  # loop by address space because of how the logic is set up
  # There will always be 2 CIDR blocks and 2 VPCs for this application
  # I'm using the VPC_address_space variable as a counter for convenience
  # I could also use var.public_subnet_01 and loop through it
  count                   = length(var.vpc_address_space)
  vpc_id                  = aws_vpc.VPC[count.index].id
  cidr_block              = var.public_subnet_01[count.index]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSN-01-${var.vpc_address_space[count.index]}"
  }
}

# Associate the public route table with the publicSN-01
resource "aws_route_table_association" "publicRT_SN-01" {
  # Note: This logic will follow for publicSN-01-A/B, publicSN-02-A/B
  # The public Subnet has a route that
  count          = length(var.vpc_address_space)
  subnet_id      = aws_subnet.publicSN-01[count.index].id
  route_table_id = aws_route_table.publicRT[count.index].id
}

# Create a public subnet
# This will be for subnet-public-02 for VPC-A and VPC-B
resource "aws_subnet" "publicSN-02" {
  # loop by address space because of how the logic is set up
  # There will always be 2 CIDR blocks and 2 VPCs for this application
  # I'm using the VPC_address_space variable as a counter for convenience
  # I could also use var.public_subnet_02 and loop through it
  count                   = length(var.vpc_address_space)
  vpc_id                  = aws_vpc.VPC[count.index].id
  cidr_block              = var.public_subnet_02[count.index]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "publicSN-02-${var.vpc_address_space[count.index]}"
  }
}

# Associate the public route table with the publicSN-02
resource "aws_route_table_association" "publicRT_SN-02" {
  count          = length(var.vpc_address_space)
  subnet_id      = aws_subnet.publicSN-02[count.index].id
  route_table_id = aws_route_table.publicRT[count.index].id
}

# Create public route table
resource "aws_route_table" "privateRT" {
  count  = length(var.vpc_address_space)
  vpc_id = aws_vpc.VPC[count.index].id
  tags = {
    Name = "privateRT-${var.vpc_address_space[count.index]}"
  }
}

# Create a private subnet
resource "aws_subnet" "privateSN-01" {
  count             = length(var.vpc_address_space)
  vpc_id            = aws_vpc.VPC[count.index].id
  cidr_block        = var.private_subnet_01[count.index]
  availability_zone = var.availability_zones[2]
  tags = {
    Name = "privateSN-01-${var.vpc_address_space[count.index]}"
  }
}

# Associate the public route table with the privateSN-01
resource "aws_route_table_association" "privateRT_SN-01" {
  count          = length(var.vpc_address_space)
  subnet_id      = aws_subnet.privateSN-01[count.index].id
  route_table_id = aws_route_table.privateRT[count.index].id
}

# Create a private subnet
resource "aws_subnet" "privateSN-02" {
  count             = length(var.vpc_address_space)
  vpc_id            = aws_vpc.VPC[count.index].id
  cidr_block        = var.private_subnet_02[count.index]
  availability_zone = var.availability_zones[3]
  tags = {
    Name = "privateSN-02-${var.vpc_address_space[count.index]}"
  }
}

# Associate the public route table with the privateSN-01
resource "aws_route_table_association" "privateRT_SN-02" {
  count          = length(var.vpc_address_space)
  subnet_id      = aws_subnet.privateSN-02[count.index].id
  route_table_id = aws_route_table.privateRT[count.index].id
}

# Create a security group
resource "aws_security_group" "ssh_web_SG" {
  # I could have left the name and description values as hard-coded
  # however, the project specifically mentioned to make this project as
  # modular as possible. Just in-case someone wants to change the name or description later.
  name        = var.SG_ssh_web_data[0] # the name of the security group
  description = var.SG_ssh_web_data[1] # the description of the security group
  # This will be applied to both VPC-A and VPC-B
  count  = length(var.vpc_address_space)
  vpc_id = aws_vpc.VPC[count.index].id
  ingress {
    description = "Allow inbound SSH traffic"
    cidr_blocks = [var.public_cidr_block]
    from_port   = var.ports[0]     # port 22
    to_port     = var.ports[0]     # port 22
    protocol    = var.protocols[0] # protocol tcp
  }
  ingress {
    description = "Allow inbound HTTP traffic"
    cidr_blocks = [var.public_cidr_block]
    from_port   = var.ports[1]     # port 80
    to_port     = var.ports[1]     # port 80
    protocol    = var.protocols[0] # protocol tcp
  }
  egress {
    description = "Allow all outbound traffic"
    cidr_blocks = [var.public_cidr_block]
    from_port   = var.ports[2]     # port 0
    to_port     = var.ports[2]     # port 0
    protocol    = var.protocols[1] # protocol: -1 (any)
  }
  tags = {
    Name = var.SG_ssh_web_data[0] # the name of the security group
  }
}

# Create EC2 instance
resource "aws_instance" "ec2-01" {
  # This will create an EC2 instance in VPC-A and VPC-B in us-east-1a
  count                  = length(var.vpc_address_space)
  ami                    = var.ec2_instance_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_instance_key
  vpc_security_group_ids = [aws_security_group.ssh_web_SG[count.index].id]
  subnet_id              = aws_subnet.publicSN-01[count.index].id
  user_data              = local.webserver_bootstrap
  tags = {
    Name = "EC2-01-${var.vpc_address_space[count.index]}"
  }
}

# Create EC2 instance
resource "aws_instance" "ec2-02" {
  # This will create an EC2 instance in VPC-A and VPC-B in us-east-1b
  count                  = length(var.vpc_address_space)
  ami                    = var.ec2_instance_ami
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_instance_key
  vpc_security_group_ids = [aws_security_group.ssh_web_SG[count.index].id]
  subnet_id              = aws_subnet.publicSN-02[count.index].id
  user_data              = local.webserver_bootstrap
  tags = {
    Name = "EC2-02-${var.vpc_address_space[count.index]}"
  }
}

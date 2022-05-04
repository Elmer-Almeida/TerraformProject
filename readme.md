# Terraform Project for AWS

This project creates two VPCs. In each VPC, there are 2 public subnets, an internet gateway, and 2 EC2 instances are created.

The EC2 instances are connected to the public subnets to deliver a bootstraped webserver.

## Structure

> provider.tf

Contains all AWS provider related data. Includes the AWS credentials.

> main.tf

Contains all the implementations to create resources in AWS. It is the main file for the project.

> variables.tf

Contains all the variable definitions used in "main.tf".

## Details

### VPC-A

- VPC-A is in the CIDR block 10.0.0.0/16.
- Has a public subnet 10.0.1.0/24 in the availability zone: us-east-1a.
- Has another public subnet 10.0.3.0/24 in the availability zone: us-east-1b.
- Has a webserver with a t2.micro instance in the public subnet 10.0.1.0/24.
- Has another webserver with a t2.micro instance in the public subnet 10.0.3.0/24.
- Has a private subnet 10.0.2.0/24 in the availability zone: us-east-1c.
- Has another private subnet 10.0.4.0/24 in the availability zone: us-east-1d.

### VPC-B

- VPC-B is in the CIDR block 192.168.0.0/16.
- Has a public subnet 192.168.1.0/24 in the availability zone: us-east-1a.
- Has another public subnet 192.168.3.0/24 in the availability zone: us-east-1b.
- Has a webserver with a t2.micro instance in the public subnet 192.168.1.0/24.
- Has another webserver with a t2.micro instance in the public subnet 192.168.3.0/24.
- Has a private subnet 192.168.2.0/24 in the availability zone: us-east-1c.
- Has another private subnet 192.168.4.0/24 in the availability zone: us-east-1d.

## Installation

```sh
# check if everything compiles and is ready to execute
terraform plan

# execute
terraform apply --auto-approve

# delete
terraform destroy
```

## Contact

Send me an email at: Elmer Almeida - [almeielm@sheridancollege.ca](almeielm@sheridancollege.ca)

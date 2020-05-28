data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

variable "environment" {
  type = string
  default = "dev"
}

resource "aws_instance" "dev" {
  count = "${var.environment == "dev" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform_private_sgdev.name}"]
  subnet_id = "${aws_subnet.public-subnet.id}"
  tags = {
    Name = "HelloWorld DEV"
    Env  = var.environment
  }
}

resource "aws_instance" "hom" {
  count = "${var.environment == "hom" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform_private_sghom.name}"]
  tags = {
    Name = "HelloWorld Hom"
    Env  = var.environment
  }
}

resource "aws_instance" "prod" {
  count = "${var.environment == "prod" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.terraform_private_sgprod.name}"]
  tags = {
    Name = "HelloWorld Prod"
    Env  = var.environment
  }
}

resource "aws_security_group" "terraform_private_sgdev" {
  description = "Allow limited inbound external traffic"
  name        = "terraform_private_sgdev"

  dynamic "ingress" {
    for_each = var.default_ingress-dev
    content {
      description = ingress.value["description"]
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  tags = {
    Name = "ec2-private-sgdev"
  }
}

resource "aws_security_group" "terraform_private_sghom" {
  description = "Allow limited inbound external traffic"
  name        = "terraform_private_sghom"

  dynamic "ingress" {
    for_each = var.default_ingress-hom
    content {
      description = ingress.value["description"]
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  tags = {
    Name = "ec2-private-sghom"
  }
}

resource "aws_security_group" "terraform_private_sgprod" {
  description = "Allow limited inbound external traffic"
  name        = "terraform_private_sgprod"

  dynamic "ingress" {
    for_each = var.default_ingress-prod
    content {
      description = ingress.value["description"]
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  tags = {
    Name = "ec2-private-sgprod"
  }
}

# Define our VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
}
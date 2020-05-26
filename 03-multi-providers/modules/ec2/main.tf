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

resource "aws_security_group" "sgdev" {
  count = "${var.environment == "dev" ? 1 : 0}"
  name = "sgdev"
  description = "Allow all inbound traffic"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  aws_security_group.sgdev.id = "1"
}

resource "aws_security_group" "sghom" {
  count = "${var.environment == "hom" ? 1 : 0}"
  name = "sghom"
  description = "Allow all inbound traffic"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 9090
      to_port = 9090
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  aws_security_group.sgdev.id = "2"
}

resource "aws_security_group" "sgprod" {
  count = "${var.environment == "prod" ? 1 : 0}"
  name = "sgprod"
  description = "Allow all inbound traffic"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  aws_security_group.sgdev.id = "2"
}

resource "aws_instance" "web" {
  count = "${var.environment == "dev" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids =  [ "${aws_security_group.sgdev.id}" ]
  tags = {
    Name = "HelloWorld DEV"
    Env  = var.environment
  }
}

resource "aws_instance" "web2" {
  count = "${var.environment == "hom" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids =  [ "${aws_security_group.sghom.id}" ]
  tags = {
    Name = "HelloWorld Hom"
    Env  = var.environment
  }
}

resource "aws_instance" "web3" {
  count = "${var.environment == "prod" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids =  [ "${aws_security_group.sgprod.id}" ]
  tags = {
    Name = "HelloWorld Prod"
    Env  = var.environment
  }
}
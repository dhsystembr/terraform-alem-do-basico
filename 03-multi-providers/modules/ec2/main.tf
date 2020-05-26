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
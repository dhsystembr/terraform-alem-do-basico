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
  security_groups = ["${aws_security_group.terraform_private_sgdev.name}"]
  tags = {
    Name = "HelloWorld DEV"
    Env  = var.environment
  }
}

resource "aws_instance" "web2" {
  count = "${var.environment == "hom" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld Hom"
    Env  = var.environment
  }
}

resource "aws_instance" "web3" {
  count = "${var.environment == "prod" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld Prod"
    Env  = var.environment
  }
}


resource "aws_security_group" "terraform_private_sgdev" {
  description = "Allow limited inbound external traffic"
  vpc_id      = "${aws_vpc.terraform-vpc.id}"
  name        = "terraform_private_sgdev"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "ec2-private-sgdev"
  }
}
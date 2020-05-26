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

  tags = {
    Name = "HelloWorld UAT"
    Env  = var.environment
  }

  count = "${var.environment == "hom" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld Homol"
    Env  = var.environment
  }

  count = "${var.environment == "prod" ? 1 : 0}"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld PROD"
    Env  = var.environment
  }
}

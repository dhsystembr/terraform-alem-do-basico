module "souzaec2-dev" {
  source = "./modules/ec2"
  environment = "dev"

  providers = {
    aws = aws.dev
  }

  resource "aws_security_group" "allow+all" {
  description = "Allow limited inbound external traffic"
  name        = "terraform_ec2_private_sg"

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
    Name = "ec2-private-sg"
  }
}
}

module "souzaec2-hom" {
  source = "./modules/ec2"
  environment = "hom"

  providers = {
    aws = aws.hom
  }
}

module "souzaec2-prod" {
  source = "./modules/ec2"
  environment = "prod"

  providers = {
    aws = aws.prod
  }
}

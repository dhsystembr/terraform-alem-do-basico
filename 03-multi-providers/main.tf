module "souzaec2-dev" {
  source = "./modules/ec2"
  environment = "dev"

  providers = {
    aws = aws.dev
  }
  vpc_id      = "vpc-12345678"
  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
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

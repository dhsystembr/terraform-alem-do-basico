provider "aws" {
  region = "us-east-2"
  alias  = "dev"
  profile = "default"
}

provider "aws" {
  region = "us-east-1"
  alias  = "hom"
  profile = "default"
}

provider "aws" {
  region = "us-west-1"
  alias = "prod"
  profile = "default"
}

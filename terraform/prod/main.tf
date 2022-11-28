provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraformtraininghippo"
    key    = "hippo.prod.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source = "../modules/ec2module"
  instancetype = "t2.micro"

  aws_common_tag = {
    name = "ec2-prod-hippo"
  }
  sg_name = "prod-sg-hippo"

}

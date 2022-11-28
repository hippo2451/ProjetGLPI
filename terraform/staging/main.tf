provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraformtraininghippo"
    key    = "hippo.staging.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source = "../modules/ec2module"
  instancetype = "t2.nano"

  aws_common_tag = {
    name = "ec2-staging-hippo"
  }
  sg_name = "staging-sg-hippo"

}

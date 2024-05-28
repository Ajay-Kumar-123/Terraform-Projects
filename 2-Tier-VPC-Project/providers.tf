terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }

  backend "s3" {
    bucket = "remote-backend-infra"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-state-db"
  }
}

provider "aws" {
  region = "ap-south-1"
}

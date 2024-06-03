terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

import {
  id = "i-0f9746dc063a3fda0"
  to = "aws_instance.vm"
}
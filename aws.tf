terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

}

provider "aws" {
  region = "us-west-1"
  }


data "aws_availability_zones" "available" {}




##### VPCModule
module "vpc" {
  source                = "./modules/VPC_Mod"

}

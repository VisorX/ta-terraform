terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
  required_version = "~> 1"

  #  backend "s3" {
  #    bucket         = "<TFSTATE_BUCKET_NAME>"
  #    key            = "ta-terraform.tfstate"
  #    region         = "<TFSTATE_BUCKET_REGION>"
  #    encrypt        = true
  #    dynamodb_table = "<TFSTATE_DYNAMODB_TABLE>"
  #  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "HoussemB"
      Project     = "ta-terraform"
    }
  }
}
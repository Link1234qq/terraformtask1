terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"

  default_tags {
    tags = {
      app-name    = var.app_name
      environment = var.environment
      managed_by  = "terraform"
    }
  }
}

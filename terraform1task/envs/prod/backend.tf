terraform {
  backend "s3" {
    bucket  = "mentoring-state-bucket"
    key     = "terraform1task/prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

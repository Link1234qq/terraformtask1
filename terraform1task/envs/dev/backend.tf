terraform {
  backend "s3" {
    bucket  = "mentoring-state-bucket"
    key     = "terraform1task/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

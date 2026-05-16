# Default backend for dev.
# For prod, re-init with a different state key, e.g.:
#   terraform init -reconfigure -backend-config="key=terraform1task/prod/terraform.tfstate"
terraform {
  backend "s3" {
    bucket  = "mentoring-state-bucket"
    key     = "terraform1task/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

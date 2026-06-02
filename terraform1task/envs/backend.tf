# State key is set per environment via -backend-config (see backend-dev.hcl / backend-prod.hcl).
# Example:
#   terraform init -backend-config=backend-dev.hcl
#   terraform apply -var-file=dev.tfvars
#
#   terraform init -reconfigure -backend-config=backend-prod.hcl
#   terraform apply -var-file=prod.tfvars
terraform {
  backend "s3" {
    bucket  = "mentoring-state-bucket"
    region  = "us-east-1"
    encrypt = true
  }
}

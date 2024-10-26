terraform {
  backend "s3" {
    bucket = "dev-terraform-bkp"
    key = "rv1/terraform.tfstate"
    region = "us-east-1"
  }
}
terraform {
  backend "s3" {
    bucket = "dev-terraform-bkp"
    key = "rv2/terraform.tfstate"
    region = "us-east-1"
  }
}
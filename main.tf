# module "infra-create"{
#   for_each = var.tools
#   source = "./infra-create"
#   instance_type = each.value["instance_type"]
#   name = each.key
#   policy_name = each.value["policy_name"]
# }


module "vpc" {
  source = "./modules/vpc"
  cidr = var.vpc["cidr"]
  env = var.env
  public_subnets = var.vpc["public_subnets"]
  db_subnets = var.vpc["db_subnets"]
  app_subnets = var.vpc["app_subnets"]
  web_subnets = var.vpc["web_subnets"]
}
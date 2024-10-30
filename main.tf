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
  availability_zone = var.vpc["availability_zone"]
  default_vpc_id = var.vpc["default_vpc_id"]
  default_vpc_route_table = var.vpc["default_vpc_route_table"]
  default_vpc_cidr = var.vpc["default_vpc_cidr"]
}

module "ec2" {
  source = "./modules/ec2"
  env = var.env
  bastion_nodes = var.bastion_nodes
  vpc_id = module.vpc.vpc_id
  for_each = var.ec2
  name = each.key
  instance_type = each.value["instance_type"]
  app_port = each.value["app_port"]
  app_sg_cidr = each.value["app_sg_cidr"]
  subnet = module.vpc.subnet["web"][0]
  
}
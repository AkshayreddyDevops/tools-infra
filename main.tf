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

module "app_ec2" {
  source = "./modules/app_ec2"
  vpc_id = module.vpc.vpc_id
  for_each = var.app_ec2
  name = each.key
  instance_type = each.value["instance_type"]
  allow_port = each.value["allow_port"]
  allow_sg_cidr = each.value["allow_sg_cidr"]
  subnet_ids = module.vpc.subnet[each.value["subnet_ref"]]
  env = "${var.env}"
  bastion_nodes = var.bastion_nodes
  asg = true
}
module "db" {
  source = "./modules/app_ec2"
  for_each = var.db
  name = each.key
  instance_type = each.value["instance_type"]
  allow_port = each.value["allow_port"]
  allow_sg_cidr = each.value["allow_sg_cidr"]
  subnet_ids = module.vpc.subnet[each.value["subnet_ref"]]
  env = var.env
  bastion_nodes = var.bastion_nodes
  vpc_id = module.vpc.vpc_id
  asg = false
}

module outputs {
  source = "./modules/app_ec2"
  vpc_id = module.vpc.vpc_id
  name = "test"
  bastion_nodes = var.bastion_nodes
  instance_type = "test"
  allow_sg_cidr = "0.0.0.0/0"
  asg = false
  allow_port = 111
  subnet_ids = ["1.1.1.1"]
  env = "dev"
}
output "test" {
  value = module.outputs.test
}


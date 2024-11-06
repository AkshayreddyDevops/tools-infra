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
  depends_on = [ module.vpc, module.db ]
  source = "./modules/asg"
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
  zone_id = var.zone_id
  internal = each.value["internal"]
  lb_subnets_ids = module.vpc.subnet[each.value["lb_subnets_ref"]]
  allow_lb_sg_cidr = each.value["allow_lb_sg_cidr"]
  acm_https_arn = each.value["https_acs_arn"]
  dns_name = module.vpc.subnet[each.value["subnet_ref"]]
}
module "db" {
  depends_on = [ module.vpc ]
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
  zone_id = var.zone_id
}

module "loadbalance"{
  source = "./modules/loadbalance"
  for_each = var.load_balancer
  env = var.env
  lb_subnets_ids = module.vpc.subnet[each.value["subnet_ref"]]
  name = each.key
  allow_lg_sg_cidr = each.value["allow_lg_sg_cidr"]
  internal = each.value["internal"]
  load_balancer_type = each.value["load_balancer_type"]
  vpc_id = module.vpc.vpc_id
  subnet_ref = each.value["subnet_ref"]
} 

output test {
  value = module.vpc.subnet[module.vpc.web_subnet_ids[0]]
}
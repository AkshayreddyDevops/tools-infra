module "infra-create"{
  for_each = var.tools
  source = "./infra-create"
  instance_type = each.value["instance_type"]
  name = each.key
}



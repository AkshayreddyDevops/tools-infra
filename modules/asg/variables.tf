variable "env" {}
variable "bastion_nodes" {}
variable "name" {}
variable "instance_type" {}
variable "allow_port" {}
variable "allow_sg_cidr" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "asg" {} 
variable "zone_id" {}
variable "internal" { 
  default = null
}
variable "lb_subnets_ids" {
  default = []
}
variable "allow_lb_sg_cidr" {
  default = []
}
variable "acm_https_arn" {}
variable "dns_name" {}
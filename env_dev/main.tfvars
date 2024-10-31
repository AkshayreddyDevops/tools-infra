env = "dev"
bastion_nodes = ["172.31.40.105/32"]
vpc =  {
  cidr = "10.10.0.0/16"
  public_subnets = ["10.10.0.0/24","10.10.1.0/24"] 
  app_subnets = ["10.10.2.0/24", "10.10.3.0/24"] 
  db_subnets = ["10.10.4.0/24", "10.10.5.0/24"] 
  web_subnets = ["10.10.6.0/24", "10.10.7.0/24"] 
  availability_zone = ["us-east-1a","us-east-1b"]
  default_vpc_id = "vpc-0383f8dc981c8f13f"
  default_vpc_route_table = "rtb-0766992470b931582"
  default_vpc_cidr = "172.31.0.0/16"
}

app_ec2 = {
   frontend ={
     subnet_ref = "web"
     instance_type = "t3.small"
     app_port = 80
     app_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24"] 
   }
}
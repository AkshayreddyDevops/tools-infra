env = "dev"
bastion_nodes = ["172.31.40.105/32"]
asg = true
zone_id = "Z085093733LY1YYTUF9Q4"

vpc =  {
  cidr = "10.10.0.0/16"
  public_subnets = ["10.10.0.0/24","10.10.1.0/24"] 
  app_subnets = ["10.10.2.0/24", "10.10.3.0/24"] 
  web_subnets = ["10.10.4.0/24", "10.10.5.0/24"] 
  db_subnets = ["10.10.6.0/24", "10.10.7.0/24"] 
  availability_zone = ["us-east-1a","us-east-1b"]
  default_vpc_id = "vpc-0383f8dc981c8f13f"
  default_vpc_route_table = "rtb-0766992470b931582"
  default_vpc_cidr = "172.31.0.0/16"
}

app_ec2 = {
   frontend ={
     subnet_ref = "web"
     instance_type = "t3.small"
     allow_port = 80
     allow_sg_cidr = ["10.10.0.0/24","10.10.1.0/24"]
     allow_lb_sg_cidr = ["0.0.0.0/24"]
     internal = true
     lb_subnets_ref = "public"
     https_acs_arn = "Get arn from ACM"
   }
   catalog ={
     subnet_ref = "app"
     instance_type = "t3.small"
     allow_port = 8080
     allow_sg_cidr = ["10.10.6.0/24", "10.10.7.0/24"] 
     allow_lb_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24"]
     internal = false
     lb_subnets_ref = "app"
     https_acs_arn = null
   }
   
}

db = {
  mongo = {
    subnet_ref = "db"
    instance_type = "t3.small"
    allow_port = 27017
    allow_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24"] 
  }
  mysql = {
    subnet_ref = "db"
    instance_type = "t3.small"
    allow_port = 3306
    allow_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24"] 
  }
  rabbitmq = {
    subnet_ref = "db"
    instance_type = "t3.small"
    allow_port = 5672
    allow_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24"] 
  }
  redis = {
    subnet_ref = "db"
    instance_type = "t3.small"
    allow_port = 6379
    allow_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24"] 
  }
}


load_balancer = {
  private_lb = {
    internal = true
    load_balancer_type = "application"
    allow_lg_sg_cidr = ["10.10.2.0/24", "10.10.3.0/24","10.10.3.0/24","10.10.3.0/24"]
    subnet_ref = "app"
  }

  public = {
    internal = false
    load_balancer_type = "application"
    allow_lg_sg_cidr = ["0.0.0.0/0"]
    subnet_ref = "public"
  }
}


resource "aws_security_group" "sg" {
  name = "${var.name}-${var.env}-sg"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.bastion_nodes
  }
    ingress {
    from_port = var.allow_port
    to_port = var.allow_port
    protocol = "tcp"
    cidr_blocks = var.allow_sg_cidr
  }
  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}
# Moved to load_balancer
# resource "aws_security_group" "lbsg" {
#   name = "${var.name}-${var.env}-lbsg"
#   vpc_id = var.vpc_id
#   egress {
#     from_port = 0
#     to_port = 0
#     cidr_blocks = ["0.0.0.0/0"]
#     protocol = "-1"
#   }  
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = var.name == var.allow_lb_sg_cidr
#   }
#     ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = var.name == var.allow_lb_sg_cidr
#   }
#   tags = {
#     Name = "${var.name}-${var.env}-sg"
#   }
# }

resource "aws_launch_template" "ltemplate"{
  name = "${var.name}-${var.env}-lt"
  image_id = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  # to run env specific builds ansible/shell ect 
  # user_data = base64decode(templatefile("${path.module}/userdata.sh"), {
  #   env_name = var.env
  #   role_name = var.role_name
  # })
  tags = {
    Name = "${var.name}-${var.env}-lt"
  }
}

resource "aws_autoscaling_group" "autoscale" {
  name = "${var.name}-${var.env}-ausc"
  desired_capacity = 1
  max_size = 1
  min_size = 1
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [aws_lb_target_group.alb-tg.arns]

  launch_template {
    id = aws_launch_template.ltemplate.id
    version = "$Latest"
  }
  tag{
    key = "Name"
    propagate_at_launch = true
    value = "${var.name}-${var.env}"
  }
}

# Moved to loadbalancer
# resource "aws_lb" "alb" {
#   name = "${var.name}-${var.env}-lb"
#   internal = var.internal
#   load_balancer_type = "application"
#   subnets =  var.lb_subnets_ids 
#   security_groups = [aws_secaws_security_group.lbsg.id]
#   tags = {
#     Environment = "${var.name}-${var.env}"
#   }
# }

resource "aws_lb_target_group" "alb-tg" {
  name = "${var.name}-${var.env}-alb-tg"
  port = var.allow_port
  protocol = "http"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    path = "/health"
    timeout = 3
  }
}


# Moved to load_balancer
# resource "aws_lb_listener" "lb-lst" {
#   count = var.internal ? 1 : 0
#   load_balancer_arn = aws_lb.alb.*.arn[count.index]
#   port = 80
#   protocol = "http"

#   default_action {
#     type = "forword"
#     target_group_arn = aws_lb_target_group.alb-tg.arn
#   }
# }

# Moved to load_balancer
# resource "aws_lb_listener" "lb-lst" {
#   count = var.internal ? 0 : 1
#   load_balancer_arn = aws_lb.alb.*.arn[count.index]
#   port = "443"
#   protocol = "https"
#   ssl_policy = "ELBSecurityPolicy-2016-08"
#   certificate_arn = ""
#   default_action {
#     type = "forword"
#     target_group_arn = aws_lb_target_group.alb-tg.arn
#   }
# }

# Moved to load_balancer
# resource "aws_lb_listener" "lb-redirect-http" {
#   count = var.internal ? 0 : 1
#   load_balancer_arn = aws_lb.alb.arn
#   port = "443"
#   protocol = "http"
#   ssl_policy = "ELBSecurityPolicy-2016-08"
#   certificate_arn = ""
#   default_action {
#     type = "redirect"
#     redirect{
#       port = "80"
#       protocol = "https"
#       status_code = "http_301"
#     }
#   }
# }

resource "aws_route53_record" "lb" {
  count = var.asg ? 1 : 0
  zone_id = var.zone_id
  name = "${var.name}-${var.env}"
  type = "CNAME"
  ttl = 30
  records = [aws_lb.alb.*.dns_name[count.index]]
}
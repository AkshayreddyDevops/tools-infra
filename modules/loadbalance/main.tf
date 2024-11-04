resource "aws_security_group" "lbsg" {
  name = "${var.name}-${var.env}-lbsg"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = var.name == var.allow_lb_sg_cidr
  }
    ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = var.name == var.allow_lb_sg_cidr
  }
  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}


resource "aws_lb" "alb" {
  name = "${var.name}-${var.env}-lb"
  internal = var.internal
  load_balancer_type = "application"
  subnets =  var.subnet_ref
  security_groups = [aws_secaws_security_group.lbsg.id]
  tags = {
    Environment = "${var.name}-${var.env}"
  }
}

resource "aws_lb_listener" "lb-redirect-http" {
  count = var.internal ? 0 : 1
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = ""
  default_action {
    type = "redirect"
    redirect{
      port = "443"
      protocol = "HTTPS"
      status_code = "http_301"
    }
  }
}

resource "aws_lb_listener" "lb-lst" {
  count = var.internal ? 0 : 1
  load_balancer_arn = aws_lb.alb.*.arn[count.index]
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = ""
  default_action {
    type = "forword"
    target_group_arn = aws_lb_target_group.alb-tg.arn
    fixed_response {
      content_type = "text/plain"
      message_body = "Configuration Error"
      status_code = "500"
    }  
  }
}
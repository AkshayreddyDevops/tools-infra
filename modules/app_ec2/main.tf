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
    from_port = var.app_port
    to_port = var.app_port
    protocol = "tcp"
    cidr_blocks = var.app_sg_cidr
  }
  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}


resource "aws_launch_template" "ltemplate"{
  name = "${var.name}-${var.env}-lt"
  image_id = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
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

  launch_template {
    id = aws_launch_template.ltemplate.id
    version = "$Latest"
  }

  tag{
    key = name
    propagate_at_launch = true
    value = "${var.name}-${var.env}"
  }
}
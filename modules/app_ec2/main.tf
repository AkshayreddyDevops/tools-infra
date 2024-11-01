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


resource "aws_launch_template" "ltemplate"{
  count = var.asg ? 1 : 0
  name = "${var.name}-${var.env}-lt"
  image_id = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.name}-${var.env}-lt"
  }
}

resource "aws_autoscaling_group" "autoscale" {
  count = var.asg ? 1 : 0
  name = "${var.name}-${var.env}-ausc"
  desired_capacity = 1
  max_size = 1
  min_size = 1
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id = aws_launch_template.ltemplate[0].id
    version = "$Latest"
  }
  tag{
    key = "Name"
    propagate_at_launch = true
    value = "${var.name}-${var.env}"
  }
}

resource "aws_instance" "main" {
  count = var.asg ? 0 : 1
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.name}-${var.env}"
  }
}


output "test"{
  value = aws_launch_template.ltemplate.id
}
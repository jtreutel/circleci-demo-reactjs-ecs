#Check if hosted zone for target domain exists
data "aws_route53_zone" "nodedemo" {
  name = "jennings-circleci20.com"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_ecr_repository" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-ecr"
}

resource "aws_ecs_task_definition" "nodedemo" {
  family       = "${var.aws_resource_name_prefix}-service"
  network_mode = "awsvpc"
  container_definitions = templatefile(
    "${path.module}/task-definitions/service.json.tpl",
    {
      aws_resource_name_prefix = var.aws_resource_name_prefix,
      image_tag                = var.commit_hash,
      aws_acct_no              = data.aws_caller_identity.current.id,
      aws_region               = data.aws_region.current.name
    }
  )
}

resource "aws_ecs_cluster" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-cluster"
}





resource "aws_ecs_service" "nodedemo" {
  name            = "${var.aws_resource_name_prefix}-service"
  cluster         = aws_ecs_cluster.nodedemo.id
  task_definition = aws_ecs_task_definition.nodedemo.arn
  desired_count   = 2

  network_configuration {
    security_groups  = [aws_security_group.nodedemo_asg.id]
    subnets          = [var.subnet_id_a, var.subnet_id_b]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nodedemo.arn
    container_name   = "${var.aws_resource_name_prefix}-service"
    container_port   = 3000
  }

  depends_on = [aws_lb.nodedemo, aws_lb_listener.nodedemo, aws_lb_target_group.nodedemo]
}


resource "aws_security_group" "nodedemo_alb" {
  name        = "${var.aws_resource_name_prefix}-lb-sg"
  description = "Node app on ECS demo"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "nodedemo" {
  name               = "${var.aws_resource_name_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nodedemo_alb.id]
  subnets            = [var.subnet_id_a, var.subnet_id_b]
}

resource "aws_lb_listener" "nodedemo" {
  load_balancer_arn = aws_lb.nodedemo.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodedemo.arn
  }
}

resource "aws_lb_target_group" "nodedemo" {
  name        = "${var.aws_resource_name_prefix}-lb-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}









data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_security_group" "nodedemo_asg" {
  name        = "${var.aws_resource_name_prefix}-asg-sg"
  description = "Node app on ECS demo"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.nodedemo_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "nodedemo" {
  name                 = "${var.aws_resource_name_prefix}-lc"
  image_id             = data.aws_ami.ecs_optimized.id
  instance_type        = "t2.xlarge"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.nodedemo_asg.id]
  associate_public_ip_address = "true"
  key_name                    = var.ecs_key_pair_name
  user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.aws_resource_name_prefix}-cluster >> /etc/ecs/ecs.config
                                  EOF
}


resource "aws_autoscaling_group" "nodedemo" {
  name                 = "${var.aws_resource_name_prefix}-asg"
  max_size             = 3
  min_size             = 2
  desired_capacity     = 2
  vpc_zone_identifier  = [var.subnet_id_a, var.subnet_id_b]
  launch_configuration = aws_launch_configuration.nodedemo.name
  health_check_type    = "ELB"
}
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
  family = "${var.aws_resource_name_prefix}-service"
  container_definitions = templatefile(
    "${path.module}/task-definitions/service.json.tpl",
    {
      image_name  = "${var.aws_resource_name_prefix}",
      image_tag   = "${var.commit_hash}",
      aws_acct_no = "${data.aws_caller_identity.current.id}",
      aws_region  = "${data.aws_region.current.name}"
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


  load_balancer {
    target_group_arn = aws_lb_target_group.nodedemo.arn
    container_name   = "${var.aws_resource_name_prefix}-service"
    container_port   = 3000
  }

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
  name     = "${var.aws_resource_name_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
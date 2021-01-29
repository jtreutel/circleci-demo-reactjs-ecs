data "aws_route53_zone" "nodedemo" {
  name = "jennings-circleci20.com"
}

resource "aws_ecr_repository" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-ecr"
}

resource "aws_ecs_task_definition" "nodedemo" {
  family                = "${var.aws_resource_name_prefix}-service"
  container_definitions = file("${path.module}/task-definitions/service.json")
}

resource "aws_ecs_cluster" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-cluster"
}
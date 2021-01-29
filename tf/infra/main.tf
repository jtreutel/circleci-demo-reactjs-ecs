data "aws_route53_zone" "nodedemo" {
  name = "jennings-circleci20.com"
}

resource "aws_ecr_repository" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-ecr"
}

resource "aws_ecs_task_definition" "nodedemo" {
  family                = "${var.aws_resource_name_prefix}-service"
  container_definitions = templatefile(
    "${path.module}/task-definitions/service.json.tpl",
    {
      image_name = "${var.aws_resource_name_prefix}",
      image_tag  = "${var.commit_hash}"
    }
  )
}

resource "aws_ecs_cluster" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-cluster"
}
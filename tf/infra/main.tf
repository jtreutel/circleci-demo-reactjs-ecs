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
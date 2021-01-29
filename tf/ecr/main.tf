data "aws_route53_zone" "nodedemo" {
  name = "jennings-circleci20.com"
}

resource "aws_ecr_repository" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-ecr"
}
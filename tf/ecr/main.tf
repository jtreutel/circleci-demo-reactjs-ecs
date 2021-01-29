data "aws_route53_zone" "nodedemo" {
  name         = "jennings-circleci20.com"
  private_zone = true
}

resource "aws_ecr_repository" "nodedemo" {
  name = "${var.aws_resource_name_prefix}-ecr"
}
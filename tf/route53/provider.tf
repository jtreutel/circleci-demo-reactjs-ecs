provider "aws" {}

terraform {
  backend "s3" {
    bucket = "jennings-test-tfstate"
    key    = "node-demo/route53.tfstate"
    region = "ap-northeast-1"
  }
}
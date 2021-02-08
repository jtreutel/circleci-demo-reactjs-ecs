data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "jennings-test-tfstate"
    key    = "node-demo/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
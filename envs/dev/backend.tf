terraform {
  backend "s3" {
    bucket         = "dev-bucket-architecture-s3-bucket-ecs"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "set-dev-dynamo-db-ecs"
    encrypt        = true
  }
}

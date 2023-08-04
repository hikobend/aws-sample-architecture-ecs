locals {
  network = {
    cidr            = "10.0.0.0/24"
    azs             = ["ap-northeast-1a", "ap-northeast-1c"]
    public_subnets  = ["10.0.0.0/26", "10.0.0.64/26"]
    private_subnets = ["10.0.0.128/26", "10.0.0.192/26"]
  }
}

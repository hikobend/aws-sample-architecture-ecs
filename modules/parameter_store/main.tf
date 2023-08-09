module "database_user" {
  source = "terraform-aws-modules/ssm-parameter/aws"

  name                 = "/${var.env}/database_user"
  value                = "change me"
  ignore_value_changes = true
  secure_type          = true
}

module "database_password" {
  source = "terraform-aws-modules/ssm-parameter/aws"

  name                 = "/${var.env}/database_password"
  value                = "change me"
  ignore_value_changes = true
  secure_type          = true
}

module "secret" {
  source = "terraform-aws-modules/ssm-parameter/aws"

  name                 = "/${var.env}/database_user"
  value                = "change me"
  ignore_value_changes = true
  secure_type          = true
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  type        = "String"
  value       = "root"
  description = "db username"
}

resource "aws_ssm_parameter" "db_raw_password" {
  name        = "/db/rawpassword"
  value       = "VeryStrongPassword!"
  type        = "SecureString"
  description = "db password"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/db/password"
  value = "uninitialized"
  type  = "SecureString"

  lifecycle {
    ignore_changes = [value]
  }
}
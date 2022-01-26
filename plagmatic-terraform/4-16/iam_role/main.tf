variable "name" {}
variable "policy" {}
variable "identifier" {}

# IAMロール
resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# 信頼ポリシー
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [var.identifier]
      type        = "Service"
    }
  }
}

# IAMポリシー
resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}

# IAMロールとIAMポリシーのattach
resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = aws_iam_policy.default.arn
  role       = aws_iam_role.default.name
}

# IAMロールのnameを返却
output "iam_role_name" {
  value = aws_iam_role.default.name
}
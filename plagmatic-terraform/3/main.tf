## 変数
#variable "example_instance_type" {
#  default = "t3.micro"
#}
#
## ローカル変数
#locals {
#  example_instance_type = "t3.micro"
#}
#
## 外部データ
#data "aws_ami" "recent_amazon_linux_2" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
#  }
#
#  filter {
#    name   = "state"
#    values = ["available"]
#  }
#}
#
#provider "aws" {
#  region = "ap-northeast-1"
#}
#
#resource "aws_security_group" "example_ec2" {
#  name = "example-ec2"
#
#  # inbound
#  ingress {
#    from_port = 80
#    to_port   = 80
#    protocol  = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  # outbound
#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
#resource "aws_instance" "example" {
#  # 外部データから取得したイメージを使う
#  # ami = "ami-0c3fd0f5d33134a76"
#  ami = data.aws_ami.recent_amazon_linux_2.image_id
#
#  # 変数を使う
#  # instance_type = var.example_instance_type
#  # ローカル変数を使う
#  instance_type = local.example_instance_type
#
#  # 他のリソースの値も参照できる
#  vpc_security_group_ids = [aws_security_group.example_ec2.id]
#
#  # 組み込み関数をつかった外部ファイルの読み込み
#  user_data = file("./user_data.sh")
#}
#
## 出力
#output "example_instance_id" {
#  value = aws_instance.example.id
#}
#output "example_public_dns" {
#  value = aws_instance.example.public_dns
#}

# moduleを利用した場合
module "web_server" {
  source        = "./http_server"
  # モジュールの中でvarで参照してるやつ
  instance_type = "t3.micro"
}

output "public_dns" {
  # モジュールの中でoutputしたやつ
  value = module.web_server.public_dns
}
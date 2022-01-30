# HTTPS関連のリソースは作成しない
# 自動作成されたホストゾーンの参照
#data "aws_route53_zone" "example" {
#  name = "test.beatdjam.com"
#}

# ホストゾーンの新規作成
#resource "aws_route53_zone" "test_example" {
#  name = "test.beatdjam.com"
#}
#
#resource "aws_route53_record" "example" {
#  name    = aws_route53_zone.test_example.name
#  type    = "A"
#  zone_id = aws_route53_zone.test_example.id
#
#  alias {
#    evaluate_target_health = true
#    name                   = aws_lb.example.dns_name
#    zone_id                = aws_lb.example.zone_id
#  }
#}
#
#output "domain_name" {
#  value = aws_route53_record.example.name
#}

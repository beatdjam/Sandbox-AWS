# HTTPS関連のリソースは作成しない
#resource "aws_acm_certificate" "example" {
#  domain_name               = aws_route53_record.example.name
#  subject_alternative_names = []
#  validation_method         = "DNS"
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
# 証明書の検証用DNSレコード
#resource "aws_route53_record" "example_certification" {
#  name    = tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_name
#  type    = tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_type
#  records = [tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_value]
#  zone_id = aws_route53_zone.test_example.zone_id
#  ttl     = 60
#}
#resource "aws_acm_certificate_validation" "example" {
#  certificate_arn         = aws_acm_certificate.example.arn
#  validation_record_fqdns = [aws_route53_record.example_certification.fqdn]
#}
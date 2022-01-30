# s3のprivateバケット
resource "aws_s3_bucket" "private" {
  bucket = "private-pragmatic-terraform-beatdjam"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# ブロックパブリックアクセス
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# パブリックバケット
resource "aws_s3_bucket" "public" {
  bucket = "public-pragmatic-terraform-beatdjam"
  acl    = "public-read"
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["https://example.com"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

# ALBのログバケット
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-pragmatic-terraform-beatdjam"
  lifecycle_rule {
    enabled = true
    expiration {
      days = "180"
    }
  }
}

# バケットポリシー
data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      # ALBからログバケットに書き込むときはAWSが管理しているリージョンごとのアカウントから書き込む
      identifiers = ["582318560864"]
      type        = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}
resource "aws_s3_bucket" "bucket-desafio" {
  bucket = var.bucket_site
  acl = "public-read"
}

locals {
  s3_origin_id = aws_s3_bucket.bucket-desafio.id
}

resource "aws_s3_bucket_acl" "acl-bucket" {
  bucket = aws_s3_bucket.bucket-desafio.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "policy_website" {
  bucket = aws_s3_bucket.bucket-desafio.id 
  policy = file("policy.json")
}


resource "aws_s3_bucket_website_configuration" "websiteconfig" {
  bucket = aws_s3_bucket.bucket-desafio.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "arq-index" {
  bucket = aws_s3_bucket.bucket-desafio.bucket
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("index.html")
}

resource "aws_s3_object" "arq-error" {
  bucket = aws_s3_bucket.bucket-desafio.bucket
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("error.html")
}


##### CLOUD FRONT #####

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket-desafio.bucket_domain_name
    origin_id                = aws_s3_bucket.bucket-desafio.bucket
    #origin_path = "/index.html"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "cflogs-desafio.s3.amazonaws.com"
  }

  aliases = ["s3site.henrq.tk"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.bucket-desafio.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

price_class = "PriceClass_100"

restrictions {
  geo_restriction {
    restriction_type = "none"
    #locations = [ "US", "CA" ]
  }
}
  
viewer_certificate {
  cloudfront_default_certificate = false
  acm_certificate_arn = data.aws_acm_certificate.tls_data.arn
  ssl_support_method = "sni-only"
}
}

resource "aws_cloudfront_monitoring_subscription" "monitoring" {
  distribution_id = aws_cloudfront_distribution.s3_distribution.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}

  ##### ACM #####
data "aws_acm_certificate" "tls_data" {
  domain   = "*.henrq.tk"
  statuses = ["ISSUED"]
}


data "aws_route53_zone" "zone_route53" {
  name         = "henrq.tk"
  private_zone = false
}

resource "aws_route53_record" "record_cf" {
  zone_id = data.aws_route53_zone.zone_route53.zone_id
  name    = "s3site.henrq.tk"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
  




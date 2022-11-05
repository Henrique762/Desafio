output "endpoint_web" {
    value = aws_s3_bucket_website_configuration.websiteconfig.website_endpoint
}

output "bucket_id" {
    value = aws_s3_bucket.bucket-desafio.id
}

output "endpoint" {
    value = aws_cloudfront_distribution.s3_distribution.aliases
}
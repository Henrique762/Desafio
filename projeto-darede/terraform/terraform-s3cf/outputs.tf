output "endpoint_web" {
    value = aws_s3_bucket_website_configuration.websiteconfig.website_endpoint
}

output "record_cf" {
    value = aws_route53_record.record_cf.alias
}

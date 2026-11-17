output "s3_bucket_name" {
  description = "Frontend S3 bucket name"
  value       = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_website_url" {
  description = "Frontend website URL"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

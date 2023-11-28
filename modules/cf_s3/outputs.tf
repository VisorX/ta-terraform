## Cloudfront outputs
output "cf_id" {
  description = "The cloudfront distribution ID"
  value       = aws_cloudfront_distribution.cloudfront_distribution.id
}

output "cf_domain_name" {
  description = "The cloudfront distribution domain name"
  value       = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}

## S3 buckets outputs 
output "bucket_ids" {
  description = "Bucket Names"
  value       = aws_s3_bucket.s3_buckets[*].id
}

output "bucket_domain_names" {
  description = "Bucket domains"
  value       = aws_s3_bucket.s3_buckets[*].bucket_domain_name
}
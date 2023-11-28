## Cloudfront outputs
output "cf_id" {
  description = "The cloudfront distribution ID"
  value       = module.cloudfront_s3.cf_id
}

output "cf_domain_name" {
  description = "The cloudfront distribution domain name"
  value       = module.cloudfront_s3.cf_domain_name
}

## S3 buckets outputs 
output "bucket_ids" {
  description = "Bucket Names"
  value       = module.cloudfront_s3.bucket_ids
}

output "bucket_domain_names" {
  description = "Bucket domains"
  value       = module.cloudfront_s3.bucket_domain_names
}
## Cloudfront distribution
resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  # Default origin 
  # Google custom origin
  origin {
    domain_name = "google.com"
    origin_id   = "google"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  # S3 origins
  dynamic "origin" {
    for_each = aws_s3_bucket.s3_buckets[*]

    content {
      domain_name = origin.value.bucket_regional_domain_name
      origin_id   = origin.value.id
      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_s3_oai.cloudfront_access_identity_path
      }
      }
    }
  

  # Default cache behavior
  default_cache_behavior {
    target_origin_id = "google"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      query_string = false

      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "allow-all"
  }

  # Custom cache behavior
  dynamic "ordered_cache_behavior" {
    for_each = [for cb in var.s3_hosting_config : cb]

    content {
      path_pattern     = ordered_cache_behavior.value.cf_s3_path
      target_origin_id = "${ordered_cache_behavior.value.s3_bucket_name}${var.env_name}"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]


    forwarded_values {
      query_string = false

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.env_name} Environment"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
}

# Cloudfront Origin Access Indetity 
resource "aws_cloudfront_origin_access_identity" "cloudfront_s3_oai" {}

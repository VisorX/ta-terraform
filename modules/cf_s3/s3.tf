# S3 bucket
resource "aws_s3_bucket" "s3_buckets" {
  count  = length(var.s3_hosting_config)
  bucket = "${var.s3_hosting_config[count.index].s3_bucket_name}${var.env_name}"
}

# S3 bucket ACL
resource "aws_s3_bucket_acl" "s3_buckets_acl" {
  count = length(var.s3_hosting_config)
  bucket = aws_s3_bucket.s3_buckets[count.index].id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# S3 bucket ACL ownership
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  count = length(var.s3_hosting_config)
  bucket = aws_s3_bucket.s3_buckets[count.index].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

# S3 block ACL
resource "aws_s3_bucket_public_access_block" "s3_buckets_acl_public_access_block" {
  count                   = length(var.s3_hosting_config)
  bucket                  = aws_s3_bucket.s3_buckets[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sse_encryption" {
  count = length(var.s3_hosting_config)
  bucket = aws_s3_bucket.s3_buckets[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 versioning
resource "aws_s3_bucket_versioning" "s3_versionning" {
  count  = length(var.s3_hosting_config)
  bucket = aws_s3_bucket.s3_buckets[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket policy to enable only access from Cloudfront
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count  = length(var.s3_hosting_config)
  bucket = aws_s3_bucket.s3_buckets[count.index].id
  policy = data.aws_iam_policy_document.s3_iam_policy_document[count.index].json
}

data "aws_iam_policy_document" "s3_iam_policy_document" {
  count = length(var.s3_hosting_config)
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.s3_buckets[count.index].arn,
      "${aws_s3_bucket.s3_buckets[count.index].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_s3_oai.iam_arn]
    }
  }
}

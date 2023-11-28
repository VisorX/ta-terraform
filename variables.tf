variable "aws_region" {
  type        = string
  description = "The name of the region where the s3 bucket will be hosted"
}

variable "s3_hosting_config" {
  type        = list(any)
  description = "This specifies the s3 bucket informations and CF related path and origin"
}
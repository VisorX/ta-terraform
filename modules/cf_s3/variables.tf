variable "region" {
  type        = string
  description = "AWS regions"
}

variable "env_name" {
  type        = string
  description = "environment name"
}

variable "s3_hosting_config" {
  type        = list(any)
  description = "This specifies the s3 bucket informations and CF related path and origin"
}


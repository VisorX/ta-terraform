module "cloudfront_s3" {
  source            = "./modules/cf_s3"
  env_name          = terraform.workspace
  region            = var.aws_region
  s3_hosting_config = var.s3_hosting_config
}
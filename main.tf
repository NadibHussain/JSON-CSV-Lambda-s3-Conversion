
module "lemdaModule" {
  source = "./modules/lemda"
}

module "s3Module" {
  source = "./modules/s3"
  lemda_role_name = module.lemdaModule.lemda_role_output
  lemda_role_arn = module.lemdaModule.lambda_role_arn_output
}


module "triggerModule" {
  source = "./modules/trigger"
  s3_bucket_id = module.s3Module.aws_s3_bucket_id
  s3_bucket_arn = module.s3Module.aws_s3_bucket_arn
  lemda_function_arn = module.lemdaModule.teraform_aws_function_arn_output
}
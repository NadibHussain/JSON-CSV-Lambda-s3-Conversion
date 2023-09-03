# Adding S3 bucket as trigger to my lambda and giving the permissions
##################
variable "s3_bucket_id" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "lemda_function_arn" {
  type = string
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = var.lemda_function_arn
  principal = "s3.amazonaws.com"
  source_arn = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
bucket = "${var.s3_bucket_id}"
lambda_function {
lambda_function_arn = "${var.lemda_function_arn}"
events              = ["s3:ObjectCreated:*"]
filter_suffix       = ".json"
}

depends_on = [
      aws_lambda_permission.allow_bucket
    ]

}
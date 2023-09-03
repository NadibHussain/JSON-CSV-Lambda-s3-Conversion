resource "aws_iam_role" "lambda_role" {
 name   = "terraform_aws_lambda_role"
 assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
  ]})
}

# IAM policy for logging from a lambda

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
   ]
})
}

# Policy Attachment on the role.

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Generates an archive from content, a file, or a directory of files.

data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "${path.module}/python/"
 output_path = "${path.module}/python/data_optimizer.zip"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/data_optimizer"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "${path.module}/python/data_optimizer.zip"
 function_name                  = "data_optimizer"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "data_optimizer.lambda_handler"
 runtime                        = "python3.8"
 depends_on                     = [aws_cloudwatch_log_group.lambda_log_group]
 

}

output "lambda_role_arn_output" {
 value = aws_iam_role.lambda_role.arn
}

output "teraform_aws_function_arn_output" {
 value = aws_lambda_function.terraform_lambda_func.arn
}

output "lemda_role_output" {
 value = aws_iam_role.lambda_role.name
}


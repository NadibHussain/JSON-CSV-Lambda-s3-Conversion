data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


variable "s3_bucket_arn" {
  type = string
}

resource "aws_sns_topic" "topic" {
  name = "lambda-conversion-complete"

  policy =  jsonencode({
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:lambda-conversion-complete",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${var.s3_bucket_arn}"}
          }
      }]
  }
  )
}


resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = "nadib2015@gmail.com"
}


output "topic_arn_output" {
  value = aws_sns_topic.topic.arn
}
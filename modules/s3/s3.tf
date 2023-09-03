variable "Environment" {
  type = string
  default = "Prod-2"
}

variable "lemda_role_name" {
  type = string
}

variable "lemda_role_arn" {
  type = string
}

resource "aws_s3_bucket" "kubeshot" {
  bucket = "kubeshot-test1122"

  tags = {
    Name        = "Data-Bucket"
    Environment = var.Environment
  }
}

resource "aws_iam_policy" "Lambda_s3_policy" {
    name = "Lambda_s3_policy"
    description = "get and put permission for s3 bucket"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.kubeshot.arn}"
        }, {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.kubeshot.arn}"
        }]
    })
}

resource "aws_iam_policy_attachment" "Lambda_s3_policy_attachment" {
    name = "Lambda_s3_policy_attachment"
    roles = [ var.lemda_role_name ]
    policy_arn = aws_iam_policy.Lambda_s3_policy.arn
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.kubeshot.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.lemda_role_arn}"
            },
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.kubeshot.arn}/*"
        }
    ]
})
}


output "aws_s3_bucket_id" {
 value = aws_s3_bucket.kubeshot.id
}
output "aws_s3_bucket_arn" {
 value = aws_s3_bucket.kubeshot.arn
}
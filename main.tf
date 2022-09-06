/**
  * # README.md
  * 
  * A Terraform module to create s3 bucket for remote state.

*/

variable "owner" {
  type        = string
  description = "The owner username of the remote state bucket"
}

variable "application" {
  type        = string
  description = "The application name to identify the remote state bucket"
}

variable "tags" {
  type = map(string)
}

variable "multipart_delete" {
  type    = string
  default = "Enabled"
}

variable "multipart_days" {
  type    = number
  default = 3
}

variable "force_destroy" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "state" {
  bucket        = "${var.application}-tf-state"
  force_destroy = var.force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  
  rule {
    id                                     = "auto-delete-incomplete-after-x-days"
    status                                 = var.multipart_delete
    abort_incomplete_multipart_upload {
      days_after_initiation = var.multipart_days
    } 
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_user" "owner" {
  user_name = var.owner
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.state.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal":{
        "AWS": "${data.aws_iam_user.owner.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.state.arn}",
        "${aws_s3_bucket.state.arn}/*"
      ]
    }
  ]
}
EOF

}

output "remote_state_bucket" {
  value = aws_s3_bucket.state.bucket
}

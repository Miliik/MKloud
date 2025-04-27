resource "aws_cloudtrail" "main" {
  name                          = "kungfu-cloudtrail"
  s3_bucket_name               = var.s3_bucket_id
  include_global_service_events = true
  is_multi_region_trail        = true
  enable_logging               = true

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

data "aws_iam_policy_document" "cloudtrail_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${var.s3_bucket_arn}/AWSLogs/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.cloudtrail_policy.json
}
module "firehose" {
  source = "./cloudwatch"
  s3_bucket_arn = "${var.s3_bucket_arn}"
  s3_bucket_id = "${var.s3_bucket_id}"
}

module "cloudtrail" {
  source = "./cloudtrail"
  s3_bucket_arn = "${var.s3_bucket_arn}"
  s3_bucket_id = "${var.s3_bucket_id}"
}
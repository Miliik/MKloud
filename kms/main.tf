// modules/kms-key/main.tf
resource "aws_kms_key" "KCMSKey" {
  description             = "Key for ${var.kmsname}"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name = "tf-${var.kmsname}-kms-key"
  }
}






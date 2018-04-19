resource "aws_s3_bucket" "crbx_bucket" {
  bucket = "crbx-tf-remote-state"
  acl    = "private"

   versioning {
      enabled = true
    }

  tags {
    Name        = "crbx-tf-remote-state"
  }
}
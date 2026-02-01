resource "aws_s3_bucket" "excel_output" {
  bucket        = "abc-sales-bucket-etl"
  force_destroy = true
}
output "bucket-id" {
  value = aws_s3_bucket.eric_static_site.id
}
output "object-id" {
  value = aws_s3_bucket_object.upload_indexhtml.id
}


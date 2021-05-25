// add the resource provider
provider "aws" {
  region = var.region
}


// create a resource block that provisions a new S3 bucket in your account
resource "aws_s3_bucket" "eric_static_site" {
  bucket = var.site_domain
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = join("_", ["${terraform.workspace}", var.site_domain])
    Environment = "${terraform.workspace}"
  }
}

resource "aws_s3_bucket_object" "upload_indexhtml" {
 depends_on = [
    aws_s3_bucket.eric_static_site
  ]
  bucket = aws_s3_bucket.eric_static_site.id
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
#  etag = filemd5("./index.html")
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.eric_static_site.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.eric_static_site.arn,
          "${aws_s3_bucket.eric_static_site.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "0.0.0.0/16"
          }
        }
      },
    ]
  })
}
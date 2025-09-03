# Create an S3 bucket
resource "aws_s3_bucket" "bucket1" {
  bucket = "my-alekya-s3-bucket-987654321" # change to a unique name
}
resource "aws_s3_bucket_public_access_block" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.bucket1.id
  key          = "index.html"
  source       = "index.html" # local file
  content_type = "text/html"
}
# Configure the bucket as a website
resource "aws_s3_bucket_website_configuration" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id

  index_document {
    suffix = "index.html"
  }
}
# Add bucket policy to allow public access
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.bucket1.id
  depends_on = [aws_s3_bucket_public_access_block.bucket1] # Ensure the public access block is created first

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket1.arn}/*"
      }
    ]
  })
}


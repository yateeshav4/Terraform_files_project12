# Define an AWS EC2 instance
resource "aws_instance" "jenkinsec2" {
  ami                    = "ami-04f8d7ed2f1a54b14"
  instance_type          = "t2.medium"
  key_name               = "project12_key"
  subnet_id              = aws_subnet.public-jenkins-subnet.id
  security_groups        = [aws_security_group.jenkins-sg.id]
  associate_public_ip_address = true
  user_data              = file("jenkins.sh")
  
  tags = {
    Name = "jenkinsec2tf"
  }
}

resource "aws_s3_bucket" "my-static-web-bucket" {
  bucket = "jenkinstf-ec2-static-bucket"  # Replace with your desired bucket name

}
resource "aws_s3_bucket_website_configuration" "my-static-web-bucket" {
  bucket = aws_s3_bucket.my-static-web-bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my-static-web-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.my-static-web-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

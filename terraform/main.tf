provider "aws" {
  region = "ap-south-1"
}

variable "allowed_ip" {
  description = "The IP address allowed to access the web server."
  default     = "52.66.198.240/32"
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP traffic only from specific IP"
  vpc_id      = "vpc-08eaf3cc3da007713"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-002f6e91abff6eb96"
  instance_type = "t2.micro"
  key_name      = "natwest"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id     = "subnet-00662f9c8c17e5f53" 

  tags = {
    Name = "WebServer"
  }
}

resource "aws_s3_bucket" "static_website" {
  bucket = "natwest-unique-static-website-new"

  tags = {
    Name = "StaticWebsite"
  }
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.web_server.public_ip
}

output "s3_bucket_url" {
  description = "The website endpoint for the S3 bucket."
  value       = "http://${aws_s3_bucket.static_website.bucket}.s3-website-ap-south-1.amazonaws.com"
}

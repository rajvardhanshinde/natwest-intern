# Variables for parameterization
variable "lambda_function_name" {
  default = "my_lambda_function"
}

variable "lambda_runtime" {
  default = "python3.9" # Change to your runtime, e.g., nodejs14.x or java11
}

variable "lambda_handler" {
  default = "lambda_function.lambda_handler" # Update with your handler
}

variable "lambda_s3_bucket" {
  default = "my-lambda-deployment-bucket"
}

variable "lambda_s3_key" {
  default = "lambda_function.zip"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "natwest"
}

variable "s3_bucket_name" {
  default = "natwest-unique-static-website-new"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}

# Lambda Function Deployment
resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  role          = aws_iam_role.lambda_execution_role.arn

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_s3_key
}

# S3 Bucket for Lambda Code
resource "aws_s3_bucket" "lambda_deployment_bucket" {
  bucket = var.lambda_s3_bucket
}

# Upload Lambda Code to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_deployment_bucket.id
  key    = var.lambda_s3_key
  source = "path/to/lambda_function.zip" # Update this to the path of your .zip file
}

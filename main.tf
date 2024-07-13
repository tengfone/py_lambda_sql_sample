#----------------------------------------------------------------------------
# Variables
#----------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

#----------------------------------------------------------------------------
# Files zipping
#----------------------------------------------------------------------------
provider "archive" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/example/index.py"
  output_path = "${path.module}/lambda-functions/example/index.zip"
}

#----------------------------------------------------------------------------
# Lambda Prisma SDK Layer for Python 3.11
#----------------------------------------------------------------------------
resource "aws_s3_object" "prisma-layer-python3-11" {
  bucket      = var.s3_bucket
  key         = "prisma/prisma-py3.11-layer.zip"
  source      = "prisma/prisma-py3.11-layer.zip"
  source_hash = filebase64sha256("${path.module}/prisma/prisma-py3.11-layer.zip")
}

resource "aws_lambda_layer_version" "prisma_layer" {
  depends_on               = [aws_s3_object.prisma-layer-python3-11]
  compatible_runtimes      = ["python3.11"]
  layer_name               = "prisma-layer"
  description              = "prisma library for Python 3.11"
  compatible_architectures = ["x86_64"]

  source_code_hash = filebase64sha256("${path.module}/layers/prisma/prisma-py3.11-layer.zip")
  s3_bucket        = var.s3_bucket
  s3_key           = "prisma/prisma-py3.11-layer.zip"
}

### Do the same with the rest of the layers ###

#----------------------------------------------------------------------------
# Lambda function, adjust the zip file accordingly, ensure that you zip the 
# folder with your codes in index.py inside
#----------------------------------------------------------------------------
resource "aws_lambda_function" "lambda_function" {
  filename                       = data.archive_file.lambda_zip.output_path
  function_name                  = var.name
  description                    = var.description
  role                           = var.iam_role
  handler                        = "index.lambda_handler"
  timeout                        = var.timeout
  memory_size                    = var.memory
  reserved_concurrent_executions = -1
  runtime                        = "python3.11"
  source_code_hash               = data.archive_file.lambda_zip.output_base64sha256
  layers                         = [aws_lambda_layer_version.prisma_layer.arn] # Add multiple layers
}

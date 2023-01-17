# 命名規則は右記を参考 https://dev.classmethod.jp/articles/aws-name-rule/

provider "aws" {
  profile = "default"
  region  = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.6"
  backend "s3" {
    bucket = "dev.ksanchu.us-west-2"
    key    = "terraform/backend/simple-wsgi-on-aws"
    region = "us-west-2"
  }
}

resource "aws_instance" "sample" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

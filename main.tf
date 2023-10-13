terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}

provider "aws" {
}

provider "random" {
  # Configuration options
}
#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length = 63
  special = false
}

 resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
output "random_bucket_name" {
  #Bucket Naming Rules 
  #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
  value = random_string.bucket_name.result
}
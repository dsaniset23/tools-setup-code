terraform {
  backend "s3" {
    bucket = "roboshop-612"
    key    = "tools/terraform.state"
    region = "us-east-1"
  }
}

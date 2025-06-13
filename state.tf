terraform {
  backend "s3" {
    bucket = "roboshop-611"
    key    = "tools/terraform.state"
    region = "us-east-1"
  }
}

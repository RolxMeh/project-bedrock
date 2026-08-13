terraform {
  backend "s3" {
    bucket = "project-bedrock-tf-state-405872562779"
    key    = "bootstrap/terraform.tfstate"
    region = "us-east-1"
  }
}
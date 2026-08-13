terraform {
  backend "s3" {
    bucket       = "project-bedrock-tf-state-405872562779"
    key          = "project-bedrock/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
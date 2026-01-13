terraform {
  backend "s3" {
    bucket         = "sp-terraform-state"
    key            = "terraform/${terraform.workspace}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "sp-terraform-lock"
    encrypt        = true
  }
}


terraform {
  backend "s3" {
    profile      = "dev-profile"
    bucket       = "my-bucket-lambda-http-api"
    key          = "lambda-demo/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile_name
}

provider "github" {
  owner = var.github_owner
}

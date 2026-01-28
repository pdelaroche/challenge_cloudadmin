#### Provider ####
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env_01
      Owner       = "pablo@devops.com"
      Team        = "DevOps"
      Project     = "demo"
    }
  }
}
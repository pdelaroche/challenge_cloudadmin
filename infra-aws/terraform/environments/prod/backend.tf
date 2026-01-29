terraform {
  backend "s3" {
    bucket       = "bucket-terraform-state-demo"
    key          = "monitoring/prod/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
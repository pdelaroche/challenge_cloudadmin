terraform {
  backend "s3" {
    bucket       = "bucket-terraform-state-demo"
    key          = "monitoring/dev/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
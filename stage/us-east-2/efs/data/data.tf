data "terraform_remote_state" "this" {
  backend = "s3"
  config = {
	bucket = "terragrunt-efs-live-test-live-us-east-2"
	key = "stage/us-east-2/vpc/terraform.tfstate"
	region = "us-east-2"
  }
}

output "subnets" {
  value = data.terraform_remote_state.this.outputs.private_subnets
}

output "vpc_id" {
  value = data.terraform_remote_state.this.outputs.vpc_id
}


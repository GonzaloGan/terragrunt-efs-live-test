locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region = local.region_vars.locals.aws_region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "tfr:///cloudposse/efs/aws?version=0.31.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  namespace       = "eg"
  stage           = "${local.env}"
  name            = "efs-test"
  region          = "${local.region}"
  vpc_id          = dependency.vpc.outputs.vpc_id
  subnets         = dependency.vpc.outputs.private_subnets
}

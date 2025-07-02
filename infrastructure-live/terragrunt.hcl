
// This terragrunt.hcl file holds configuration that will be shared by all environments. In this case, it defines a
// single remote state backend that stores the Terraform state and state lock files for both of our environments.

remote_state {
  backend = "s3"

  // Instructs Terragrunt to generate a backend.tf file in the working directory when invoked. This eliminates the need
  // to explicitly declare the backend configuration in the Terraform code, keeping environment-specific state
  // management DRY and centralized in Terragrunt.
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket                = get_env("TF_STATE_BUCKET_NAME")
    dynamodb_table        = get_env("TF_STATE_LOCK_TABLE_NAME")
    key                   = "${path_relative_to_include()}/terraform.tfstate"
    region                = "eu-west-2"
    encrypt               = true
    disable_bucket_update = true
  }
}

terraform {
  // This tells each environment where to find the Terraform module it should use.
  source = "${path_relative_from_include()}/..//terraform"
}

inputs = {
  // This makes the name of the environment (e.g. "staging", "production") available to the Terraform as a variable.
  // by using the folder path relative to the root terragrunt.hcl.
  environment = path_relative_to_include()
}


remote_state {
  backend = "s3"
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
  source = "${path_relative_from_include()}/..//terraform"
}

inputs = {
  environment = path_relative_to_include()
}

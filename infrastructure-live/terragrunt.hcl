
terraform {
  source = "${path_relative_from_include()}/..//terraform"
}

inputs = {
  environment = path_relative_to_include()
}

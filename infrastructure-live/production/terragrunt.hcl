
// Inherit the configuration defined in /infrastructure-live/terragrunt.hcl.
include {
  path = find_in_parent_folders()
}

# Get caller identities for the various providers, so that local variables
# below can be derived.

data "aws_caller_identity" "images_production" {
  provider = aws.images-production-ami
}

data "aws_caller_identity" "images_staging" {
  provider = aws.images-staging-ami
}

# Retrieve the effective Account ID, User ID, and ARN in which Terraform is
# authorized.  This is used to calculate the session names for assumed roles.
data "aws_caller_identity" "terraform_backend" {
  provider = aws.cool-terraform-backend
}

# The default caller identity corresponds to the Users account.
# This is needed to determine the Users account ID.
data "aws_caller_identity" "users" {
}

locals {
  test_user_name = "test-nessus-packer"

  # Extract the user name of the caller for use in assumed role session names.
  caller_user_name = split("/", data.aws_caller_identity.terraform_backend.arn)[1]

  # Grab all of the necessary account IDs
  images_production_account_id = data.aws_caller_identity.images_production.account_id

  images_staging_account_id = data.aws_caller_identity.images_staging.account_id

  users_account_id = data.aws_caller_identity.users.account_id
}

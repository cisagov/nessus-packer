# Provider that is only used for obtaining the caller identity.
# Note that we cannot use a provider that assumes a role via an ARN from a
# Terraform remote state for this purpose (like we do for all of the other
# providers below).  This is because we derive the session name (in the
# assume_role block within the provider) from the caller identity of this
# provider; if we try to do that, it results in a Terraform "Cycle" error.
# Hence, for our caller identity, we use a provider based on a profile that
# must exist for the Terraform backend to work ("cool-terraform-backend").
provider "aws" {
  alias   = "cool-terraform-backend"
  region  = "us-east-1"
  profile = "cool-terraform-backend"
}

# Default AWS provider (ProvisionAccount for the Users account)
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.users.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
}

# ProvisionEC2AMICreateRoles AWS provider for the Images Production account
provider "aws" {
  alias  = "images-production-ami"
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.images_production.outputs.provisionec2amicreateroles_role.arn
    session_name = local.caller_user_name
  }
}

# ProvisionParameterStoreReadRoles AWS provider for the Images Production account
provider "aws" {
  alias  = "images-production-ssm"
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.images_parameterstore_production.outputs.provisionparameterstorereadroles_role.arn
    session_name = local.caller_user_name
  }
}

# ProvisionEC2AMICreateRoles AWS provider for the Images Staging account
provider "aws" {
  alias  = "images-staging-ami"
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.images_staging.outputs.provisionec2amicreateroles_role.arn
    session_name = local.caller_user_name
  }
}

# ProvisionParameterStoreReadRoles AWS provider for the Images Staging account
provider "aws" {
  alias  = "images-staging-ssm"
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.images_parameterstore_staging.outputs.provisionparameterstorereadroles_role.arn
    session_name = local.caller_user_name
  }
}

# ProvisionThirdPartyBucketReadRoles AWS provider
# for the Images Production account
provider "aws" {
  alias  = "images-production-s3"
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.images_production.outputs.provisionthirdpartybucketreadroles_role.arn
    session_name = local.caller_user_name
  }
}

# ProvisionThirdPartyBucketReadRoles AWS provider
# for the Images Staging account
provider "aws" {
  alias  = "images-staging-s3"
  region = "us-east-1"
  assume_role {
    role_arn     = data.terraform_remote_state.images_staging.outputs.provisionthirdpartybucketreadroles_role.arn
    session_name = local.caller_user_name
  }
}

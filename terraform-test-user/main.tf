module "third_party_bucket_read_production" {
  source = "github.com/cisagov/s3-read-role-tf-module"

  providers = {
    aws = aws.images-production-s3
  }

  account_ids   = [local.users_account_id]
  entity_name   = local.test_user_name
  iam_usernames = [local.test_user_name]
  role_name     = "ThirdPartyBucketRead-${local.test_user_name}"
  s3_bucket     = data.terraform_remote_state.images_production.outputs.third_party_bucket.id
  s3_objects    = ["Nessus-?.?.?-debian6_amd64.deb"]
}

module "third_party_bucket_read_staging" {
  source = "github.com/cisagov/s3-read-role-tf-module"

  providers = {
    aws = aws.images-staging-s3
  }

  account_ids   = [local.users_account_id]
  entity_name   = local.test_user_name
  iam_usernames = [local.test_user_name]
  role_name     = "ThirdPartyBucketRead-${local.test_user_name}"
  s3_bucket     = data.terraform_remote_state.images_staging.outputs.third_party_bucket.id
  s3_objects    = ["Nessus-?.?.?-debian6_amd64.deb"]
}

module "iam_user" {
  source = "github.com/cisagov/ami-build-iam-user-tf-module"

  providers = {
    aws                       = aws
    aws.images-production-ami = aws.images-production-ami
    aws.images-staging-ami    = aws.images-staging-ami
    aws.images-production-ssm = aws.images-production-ssm
    aws.images-staging-ssm    = aws.images-staging-ssm
  }

  ssm_parameters = ["/cyhy/dev/users", "/ssh/public_keys/*"]
  user_name      = local.test_user_name

  additional_policy_arns_production = [
    module.third_party_bucket_read_production.policy.arn
  ]
  additional_policy_arns_staging = [
    module.third_party_bucket_read_staging.policy.arn
  ]

  tags = {
    Team        = "CISA - Development"
    Application = "nessus-packer"
  }
}

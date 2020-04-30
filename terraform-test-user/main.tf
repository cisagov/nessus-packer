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

  tags = {
    Team        = "CISA - Development"
    Application = "nessus-packer"

  }
}

module "third_party_bucket_read_production" {
  source = "github.com/cisagov/s3-read-role-tf-module"

  providers = {
    aws = aws.images-production-s3
  }

  account_ids   = [local.users_account_id]
  entity_name   = module.iam_user.user.name
  iam_usernames = [module.iam_user.user.name]
  role_name     = "ThirdPartyBucketRead-${module.iam_user.user.name}"
  s3_bucket     = data.terraform_remote_state.images_production.outputs.third_party_bucket.id
  s3_objects    = ["Nessus-*-debian6_amd64.deb"]
}

# Attach ThirdPartyBucketRead policy to the Production EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_production" {
  provider = aws.images-production-ami

  policy_arn = module.third_party_bucket_read_production.policy.arn
  role       = module.iam_user.ec2amicreate_role_production.name
}

module "third_party_bucket_read_staging" {
  source = "github.com/cisagov/s3-read-role-tf-module"

  providers = {
    aws = aws.images-staging-s3
  }

  account_ids   = [local.users_account_id]
  entity_name   = module.iam_user.user.name
  iam_usernames = [module.iam_user.user.name]
  role_name     = "ThirdPartyBucketRead-${module.iam_user.user.name}"
  s3_bucket     = data.terraform_remote_state.images_staging.outputs.third_party_bucket.id
  s3_objects    = ["Nessus-*-debian6_amd64.deb"]
}

# Attach ThirdPartyBucketRead policy to the Staging EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_staging" {
  provider = aws.images-staging-ami

  policy_arn = module.third_party_bucket_read_staging.policy.arn
  role       = module.iam_user.ec2amicreate_role_staging.name
}

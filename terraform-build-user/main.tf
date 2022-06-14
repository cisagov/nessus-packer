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
  user_name      = "build-nessus-packer"
}

# Attach Production ThirdPartyBucketRead policy to
# the Production EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_production" {
  provider = aws.images-production-ami

  policy_arn = data.terraform_remote_state.ansible_role_nessus.outputs.production_bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role_production.name
}

# Attach Staging ThirdPartyBucketRead policy to the Staging EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread_staging" {
  provider = aws.images-staging-ami

  policy_arn = data.terraform_remote_state.ansible_role_nessus.outputs.staging_bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role_staging.name
}

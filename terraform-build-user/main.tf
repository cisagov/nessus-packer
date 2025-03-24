module "iam_user" {
  source = "github.com/cisagov/ami-build-iam-user-tf-module"

  providers = {
    aws            = aws
    aws.images-ami = aws.images-ami
    aws.images-ssm = aws.images-ssm
  }

  ssm_parameters = [
    "/vnc/password",
    "/vnc/ssh/ed25519_private_key",
    "/vnc/ssh/ed25519_public_key",
    "/vnc/username",
  ]
  user_name = "build-nessus-packer"
}

# Attach ThirdPartyBucketRead policy to the EC2AMICreate role
resource "aws_iam_role_policy_attachment" "thirdpartybucketread" {
  provider = aws.images-ami

  policy_arn = data.terraform_remote_state.ansible_role_nessus.outputs.bucket_policy.arn
  role       = module.iam_user.ec2amicreate_role.name
}

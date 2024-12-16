data "amazon-ami" "ubuntu_noble_arm64" {
  filters = {
    architecture        = "arm64"
    name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = var.build_region
}

data "amazon-ami" "ubuntu_noble_x86_64" {
  filters = {
    architecture        = "x86_64"
    name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = var.build_region
}

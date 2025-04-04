packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "alma-linux-8-basic" {
  ami_name      = "alma-linux-8-basic-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-08c40ec9ead489471" # REPLACE WITH A VALID ALMALINUX 8 AMI IN YOUR REGION
  ssh_username  = "ec2-user" # Or the default username for your chosen AMI
  ssh_timeout   = "10m"
  tags = {
    "Name" = "AlmaLinux-8-Basic"
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    volume_size           = 8 # Or the default size of the source AMI
    delete_on_termination = true
  }

  subnet_id                 = "subnet-0fa8ee921a30245d2" # REPLACE WITH YOUR SUBnet ID
  vpc_id                    = "vpc-0879f88c398df87a8"    # REPLACE WITH YOUR VPC ID
  associate_public_ip_address = true
  security_group_ids        = ["sg-0a5d6433fa6776e70"] # REPLACE WITH YOUR Security Group ID

  access_key = "${env("aws_access_key")}" # Assuming you'll pass these via Harness
  secret_key = "${env("aws_secret_key")}" # Assuming you'll pass these via Harness
}

build {
  sources = ["source.amazon-ebs.alma-linux-8-basic"]

  provisioner "shell" {
    inline = [
      "echo 'Basic AMI created.'"
    ]
  }
}

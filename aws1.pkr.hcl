packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "node1-{{timestamp}}" 
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-003cae08fc30c80a7" 
  ssh_username  = "root"
  ssh_timeout   = "10m"
  tags = {
    "Name" = "AmazonLinux-Packer"
  }

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  subnet_id                 = "subnet-0fa8ee921a30245d2"
  vpc_id                    = "vpc-0879f88c398df87a8"
  associate_public_ip_address = true
  security_group_ids        = ["sg-0a5d6433fa6776e70"]
}

build {
  sources = ["source.amazon-ebs.amazon-linux"]

  provisioner "shell" {
    inline = [
      "touch /tmp/test.txt"
    ]
  }
}

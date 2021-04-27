terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.37.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region = "us-east-1"

}

# Setting up hosted zone for gitlab

#resource "aws_route53_zone" "gitlab_zone" {
  #name = "gitlab.sapphiresuns.com"

 # tags = {
  #  Environment = "Prod"
 # }
#}

resource "aws_route53_record" "www" {
  zone_id = "Z0307079E1G8FNSKVGIT"
  #zone_id = aws_route53_zone.gitlab_zone.zone_id
  name    = "gitlab.sapphiresuns.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.gitlab_instance.public_ip]
}




# Setting up Name Servers for gitlab hosted zones

#resource "aws_route53_record" "gitlab-ns" {
 # zone_id = aws_route53_zone.gitlab_zone.zone_id
  #name    = "gitlab.sapphiresuns.com"
 # type    = "NS"
 # ttl     = "30"
  #records = aws_route53_zone.gitlab_zone.name_servers
#}

data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "gitlab_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.medium"
  key_name = "sapphirekey"
  tags = {
    Name = "GitLab Instance"
  }
}
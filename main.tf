provider "aws" {
  region = "us-west-2"

}

provider "github" {
  token = var.git_token
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
}


data "github_repository" "existing_repo" {
  full_name = "AizazZaidee/docker-bookstore"
}

output "repo_url" {
  value = data.github_repository.existing_repo.html_url
}


variable "files" {
  default = ["main.tf", "userdata.sh", "bookstore-api.py", "Dockerfile", "requirements.txt", "compose.yml"]
  type    = list(string)
}

variable "git_token" {
  type      = string
  sensitive = true
}

variable "key_name" {
  type      = string
  sensitive = true
}

resource "github_repository_file" "app-files" {
  for_each            = toset(var.files)
  file                = each.value
  content             = file(each.value)
  repository          = data.github_repository.existing_repo.name
  branch              = "main"
  commit_message      = "Adding file: ${each.value} through terraform"
  overwrite_on_create = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_security_group" "tf-docker-sg" {
  name = "tf-docker-sg"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "tf-docker-instance" {
  ami             = "ami-0005ee01bca55ab66"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.tf-docker-sg.name]

  tags = {
    Name = "tf-docker-instance"
  }

  user_data = templatefile("userdata.sh", {
    user-data-git-token     = var.git_token
    user-data-git-user-name = "AizazZaidee"
  })

  depends_on = [github_repository_file.app-files, ]
}
output "website-url" {
  value = aws_instance.tf-docker-instance.public_ip

}

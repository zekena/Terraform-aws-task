provider "aws" {
  region                  = var.region
  shared_credentials_file = var.credentials
  profile                 = var.profile
}

resource "aws_key_pair" "ubuntu" {
  key_name   = "ubuntu"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "ssh" {
  name        = "ssh-security-group"
  description = "allow ssh access to the ec2 instance"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.trusted_ip]
  }

  tags = {
    Name = "SSH"
  }
}

resource "aws_instance" "ec2_instance" {
  key_name      = aws_key_pair.ubuntu.key_name
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"

  tags = {
    Name = "EC2 instance"
  }

  vpc_security_group_ids = [aws_security_group.ssh.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}

resource "aws_eip" "ubuntu" {
  vpc      = true
  instance = aws_instance.ec2_instance.id
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "malwarebytes-state"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "malwarebytes-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    key = "global/s3/terraform.tfstate"
  }
}

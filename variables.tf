variable "region" {
  default = "eu-central-1"
}

variable "profile" {
  default = "zekena"
}

variable "credentials" {
  default = "~/.aws/credentials"
}

variable "public_key_path" {
  default = "key.pub"
}

variable "private_key_path" {
  default = "key"
}

variable "trusted_ip" {
  default = "0.0.0.0/0"
}

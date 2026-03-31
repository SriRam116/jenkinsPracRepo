variable "region" {
  description = "region info"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "aws profile info"
  type        = string
  default     = "pipePrac"
}

variable "amiID" {
  description = "aws machine ID"
  type        = string
  default     = "ami-0ec10929233384c7f"
}

variable "instanceType" {
  description = "aws instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "ssh key"
  type        = string
  default     = ""
}

variable "public_key" {
  description = "public key path"
  type        = string
  default     = ""
}
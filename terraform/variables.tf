variable "region" {
  description = "region info"
  type        = string
  default     = ""
}

variable "profile" {
  description = "aws profile info"
  type        = string
  default     = ""
}

variable "amiID" {
  description = "aws machine ID"
  type        = string
  default     = ""
}

variable "instanceType" {
  description = "aws instance type"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "ssh key"
  type        = string
  default     = ""
}

variable "key_path" {
  description = "public key path"
  type        = string
  default     = ""
}
variable "identifier" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}
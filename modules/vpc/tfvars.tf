variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
}

variable "azs" {
  type = list
}

variable "public-subnets" {
  type = list
}

variable "private-subnets" {
  type = list
}

variable "dataprocessing-private-subnets" {
  type = list
}

variable "db-private-subnets" {
  type = list
}

variable "env" {
    type = string
}

variable "environment" {
    type = string
}

variable "gap-vpc-cidr" {
  type = string
}

variable "ev-vpc-cidr" {
  type = string
}

variable "smartpath-vpc-cidr" {
  type = string
}

variable "chatbot-vpc-cidr" {
  type = string
}


variable "analytics-vpc-cidr" {
  type = string
}

variable "evintegration-vpc-cidr" {
  type = string
}

variable "zones" {
  default = {
    zone0 = "us-east-1a"
    zone1 = "us-east-1b"
    zone2 = "us-east-1c"
  }
}

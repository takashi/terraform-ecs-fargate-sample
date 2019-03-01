variable "name" {
  default = "APPNAME"
}

variable "dns" {
  default = "example.com"
}

variable "bucket" {
  default = "APPNAME"
}

variable "bucket_domain" {
  default = "APPNAME.s3.amazonaws.com"
}

variable "common" {
  default = {
    default.availability_zones = "ap-northeast-1a,ap-northeast-1c"
  }
}

variable "subnets" {
  type = "map"

  default = {
    default.public  = ""
    default.nat     = ""
    default.rds     = ""
    default.bastion = ""

    prd.public  = "10.0.0.0/24,10.0.1.0/24"
    prd.rds     = "10.0.2.0/24,10.0.3.0/24"
    prd.nat     = "10.0.4.0/24,10.0.5.0/24"
    prd.bastion = "10.0.6.0/24"
  }
}

variable "vpc" {
  type = "map"

  default = {
    default.cidr = ""

    prd.cidr = "10.0.0.0/16"
  }
}

variable "region" {}

variable "alb_certificate_arn" {
  default = ""
}

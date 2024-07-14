variable "a_records" {
  type    = list(string)
  default = ["1.2.3.4"]
}

variable "amount_limitation" {
  type    = number
  default = 1000
}

variable "app_asg_max" {
  type    = number
  default = 3
}

variable "app_asg_min" {
  type    = number
  default = 1
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "app_subnets" {
  type = map(any)
  default = {
    a = {
      name = "snet_app_a"
      cidr = "10.0.1.0/24"
    }
    b = {
      name = "snet_app_b"
      cidr = "10.0.2.0/24"
    }
  }
}

variable "bucket_name" {
  type    = string
  default = "bb-webapp"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "db_subnets" {
  type = map(any)
  default = {
    a = {
      name = "snet_db_a"
      cidr = "10.0.5.0/24"
    }
    b = {
      name = "snet_db_b"
      cidr = "10.0.6.0/24"
    }
  }
}

variable "dns_zone" {
  type    = string
  default = "webapp.brainboard.co"
}

variable "domains" {
  type    = list(string)
  default = ["domain.com"]
}

variable "ec2_amount_limitation" {
  type    = number
  default = 500
}

variable "ec2_threshold" {
  type    = number
  default = 400
}

variable "email" {
  type    = string
  default = "contact@brainboard.co"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "hosted_zone" {
  type    = string
  default = "webapp.brainboard.co"
}

variable "image_id" {
  description = "The AMI of the image used in the launch template. Put your own AMI here for the specified region."
  type        = string
  default     = "ami-0c7217cdde317cfec"
}

variable "ipset_value" {
  type    = string
  default = "192.0.7.0/24"
}

variable "rds_db_name" {
  type    = string
  default = "brainboard"
}

variable "rds_master_password" {
  type    = string
  default = "Bra1nb0ard123"
}

variable "rds_master_username" {
  type    = string
  default = "masteruser"
}

variable "s3_amount" {
  type    = number
  default = 100
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "ce92659b-7679-4b45-a40b-ecb11dfb8022"
    env      = "Development"
  }
}

variable "threshold" {
  type    = number
  default = 800
}

variable "web_asg_max" {
  type    = number
  default = 3
}

variable "web_asg_min" {
  type    = number
  default = 1
}

variable "web_subnets" {
  type = map(any)
  default = {
    a = {
      name = "snet_web_a"
      cidr = "10.0.3.0/24"
    }
    b = {
      name = "snet_web_b"
      cidr = "10.0.4.0/24"
    }
  }
}


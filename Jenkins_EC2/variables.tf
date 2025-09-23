variable "region" {
    description = "AWS region"
    type = string
}

variable "profile" {
    description = "AWS profile"
    type = string
}

variable "az" {
    description = "Availability zone"
    type = string  
}

variable "my_ip" {
    description = "Allowed Cidr"
    type = string
    sensitive = true
}

variable "instance_type" {
    description = "Instance type"
    type = string 
}

variable "kp" {
    description = "key pair"
    type = string
    sensitive = true
}
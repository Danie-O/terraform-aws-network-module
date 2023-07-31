variable "region" {
    description = "AWS Region"
    type = string
    default = "us-east-2"
}

variable "availability_zones" {
    description = "Availability Zones"
    type        = list(string)
    default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "application_name" {
    description = "Set application name(eg. prod, dev.etc)"
    type        = string
    default     = "example-app"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

# variable "vpc_id" { 
#     type = string
# }

variable "default_route" {
    description = "Default Route from and to the internet"
    type        = string
    default     = "0.0.0.0/0"
}

variable "tenancy" {
    default = "default"
}

variable "true" {
    type = bool
    default = true
}

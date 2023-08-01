provider "aws" {
    region = "${var.region}"
    profile = "terraform-user"
}

data "aws_availability_zones" "available" { }

module "network" {
    source = "./modules/network"
    availability_zones = "${var.availability_zones}"
    application_name = var.application_name
}
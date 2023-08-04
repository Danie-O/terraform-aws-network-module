output "vpc_id" {
    value = module.network.vpc_id
}

output "internet_gateway_id" {
    value = module.network.internet_gateway_id
}

output "nat_gateway_id" {
    value = module.network.nat_gateway_id
}

# output "first_public_subnet_id" {
#   value = module.network.first_public_subnet_id
# }

output "imported_public_subnet_ids" {
  value = module.network.public_subnet_ids
}
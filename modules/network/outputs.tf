output "vpc_id" {
    value = aws_vpc.terraform_vpc.id
}

output "nat_gateway_eip_id" {
    value = aws_eip.nat_gateway_eip.id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.internet_gateway.id
}

output "nat_gateway_id" {
    value = aws_nat_gateway.nat_gateway.id
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet.*.id
}

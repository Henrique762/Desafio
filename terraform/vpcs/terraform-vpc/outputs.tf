output "id-vpc" {
    value = aws_vpc.geral.id
}

output "id-subnetprivate1" {
    value = aws_subnet.private1.id
}

output "id-subnetprivate2" {
    value = aws_subnet.private2.id
}

output "id-subnetpublic1" {
    value = aws_subnet.public1.id
}

output "id-subnetpublic2" {
    value = aws_subnet.public1.id
}

output "id-subnetdb1" {
    value = aws_subnet.database-1.id
}

output "id-subnetdb2" {
    value = aws_subnet.database-2.id
}

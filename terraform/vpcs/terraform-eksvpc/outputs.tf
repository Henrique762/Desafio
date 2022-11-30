output "id-vpc" {
    value = aws_vpc.eks-vpc.id
}

output "id-subnetprivate1" {
    value = aws_subnet.eks-private1.id
}

output "id-subnetprivate2" {
    value = aws_subnet.eks-private2.id
}

output "id-subnetpublic1" {
    value = aws_subnet.eks-public1.id
}

output "id-subnetpublic2" {
    value = aws_subnet.eks-public1.id
}

output "id-subnetdb1" {
    value = aws_subnet.eks-database-1.id
}

output "id-subnetdb2" {
    value = aws_subnet.eks-database-2.id
}

output "id-security-group" {
    value = aws_security_group.allow_http.id
}
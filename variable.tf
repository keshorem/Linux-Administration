variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
    description = "CIDR block for subnet"
    default = "10.0.0.0/24"
}


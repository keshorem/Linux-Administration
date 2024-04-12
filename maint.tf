resource "aws_vpc" "vpc_for_aws_resource" {
    vpc_id = ""
    enable_dns_support = true
    enable_dns_hostname = true

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }
}

resource "aws_subnet" "configuring_vpc" {
    vpc_id = ""
    cidr_block = ""
    availability_zone = ""
    map_public_ip_on_launch = ""
}

resource "aws_security_group" "sg_for_app"{
    vpc_id = ""
    name = ""
    description = ""
    ingress {
        security_groups = []
        from_port = 
        to_port = 
        protocol =
    }

    egress {
        security_groups = []
        from_port = 
        to_port = 
        protocol = 
    }

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }
}

resource "aws_dynamodb_table" "table_records" {
    name = "StudentInformation"
    read_capacity = 20
    write_capacity = 20
    hash_key = "studentid"
    range_key = "studentcourse"

    attribute {
        name = "studentid"
        type = "S"
    }

    attribute {
        name = "studentcourse"
        type = "S"
    }

    attribute {
        name = "courseprice"
        type = "N"
    }

    global_secondary_index {
        name = "StudentDashboard"
        hash_key = "studentcourse"
        range_key = "courseprice"
        write_capacity = 10
        read_capacity = 10
        non_key_attributes = ["studentid"]
    }

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }

}

resource "aws_vpc_endpoint" "connect_to_dynamodb"{
    vpc_id = aws_vpc.main.id
    service_name = ""
    vpc_endpoint_type = ""
    private_dns_enabled = true
}

resource "aws_instance" "private_subnet" {
    ami_id = ""
    instance_type = ""
    subnet_id = ""
    vpc_security_ids = ""

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }

}
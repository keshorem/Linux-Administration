resource "aws_vpc" "vpc_for_aws_resource" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_support = true
    enable_dns_hostname = true

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }
}

resource "aws_subnet" "configuring_vpc" {
    vpc_id = "${aws_vpc.cidr_block}"
    cidr_block = "${var.subnet_cidr_block}"
    availability_zone = "us-east-1"
}

resource "aws_security_group" "sg_for_app"{
    vpc_id = "${aws_vpc.cidr_block}"
    name = "private security group"
    description = "private security group with various inbound and outbound rules"
    ingress {
        security_groups = ["${aws_security_group.sg_for_app.id}"]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    egress {
        cidr_block = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
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

resource "aws_vpc" "vpc_for_aws_resource" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }
}

resource "aws_subnet" "configuring_vpc" {
    vpc_id = aws_vpc.vpc_for_aws_resource.id
    cidr_block = "${var.subnet_cidr_block}"
    availability_zone = "us-east-1a"
}

resource "aws_security_group" "sg_for_app"{
    vpc_id = aws_vpc.vpc_for_aws_resource.id
    name = "private security group"
    description = "private security group with various inbound and outbound rules"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
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
        projection_type = "INCLUDE"
    }

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }

}

resource "aws_vpc_endpoint" "connect_to_dynamodb"{
    vpc_id = aws_vpc.vpc_for_aws_resource.id
    service_name = "com.amazonaws.us-east-1.dynamodb"
    vpc_endpoint_type = "Interface"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
    }
}

data "aws_subnet" "get_subnet_id" {
  id = aws_subnet.configuring_vpc.id
}

resource "aws_instance" "launch_ec2_instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.get_subnet_id.id
    security_groups = [aws_security_group.sg_for_app.id]
    associate_public_ip_address = true
    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }

}

resource "tls_private_key" "instance_key" {
    algorithm = "RSA"
}

resource "aws_key_pair" "generate_key_pair" {
    key_name = "instance_key"
    public_key = tls_private_key.instance_key.public_key_openssh
    depends_on = [
        tls_private_key.instance_key
    ]
}

resource "local_file" "generate_pem_file"{
    content = tls_private_key.instance_key.private_key_pem
    filename = "key-value.pem"
    file_permission = "0400"
    depends_on = [
        tls_private_key.instance_key
    ]
}

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
    service_name = "dynamodb.us-east-1.amazonaws.com"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
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
    ami_id = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.get_subnet_id
    key_name = aws_key_pair.generate_key_pair.key_name
    vpc_security_ids = [aws_security_group.sg_for_app.id]
    associate_public_ip_address = true
    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }

}
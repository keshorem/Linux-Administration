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

    global_secondary_index {
        name = "StudentDashboard"
        hash_key = "studentid"
        range_key = "studentcourse"
        write_capacity = 10
        read_capacity = 10
        non_key_attributes = ["studentid"]
    }

    tags = {
        Project = "vpcendpoint-dynamodb-table"
    }

}
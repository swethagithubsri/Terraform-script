#Creating VPC

resource "aws_vpc" "Nimesa-assignment-vpc" {
    cidr_block = var.vpc-cidr
    tags = {
        purpose = "assignment"
    }

}

#Creating Public Subnet

resource "aws_subnet" "Nimesa-public-subnet" {
    vpc_id = aws_vpc.Nimesa-assignment-vpc.id
    cidr_block = var.public-subnet
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = true
    tags = {
        purpose = "assignment"
    }
}

#Creating Private Subnet

resource "aws_subnet" "Nimesa-private-subnet" {
    vpc_id = aws_vpc.Nimesa-assignment-vpc.id
    cidr_block = var.private-subnet
    tags = {
        purpose = "assignment"
    }
}


#Creating IGW to make subnet as public subnet
resource "aws_internet_gateway" "Nimesa-igw" {
    vpc_id = aws_vpc.Nimesa-assignment-vpc.id
        tags = {
       purpose = "assignment"
    }

}

#Creating route table to making routes and associate route table accordingly
#Here are going to create two route table one route table for public subnet and another one for private subnet


#public routetable creation and association
resource "aws_route_table" "Nimesa-public-route-table" {
    vpc_id = aws_vpc.Nimesa-assignment-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Nimesa-igw.id
    }
        tags = {
        purpose = "assignment"
    }    
}

resource "aws_route_table_association" "Nimesa-public-route-table-association" {
    subnet_id = aws_subnet.Nimesa-public-subnet.id
    route_table_id = aws_route_table.Nimesa-public-route-table.id
}

#Private route table
resource "aws_route_table" "Nimesa-private-route-table" {
    vpc_id = aws_vpc.Nimesa-assignment-vpc.id
            tags = {
        purpose = "assignment"
    } 
}

resource "aws_route_table_association" "Nimesa-private-route-table-association" {
    subnet_id = aws_subnet.Nimesa-private-subnet.id
    route_table_id = aws_route_table.Nimesa-private-route-table.id
}
    
 #Creating Ec2 instance in public subnet.

 resource "aws_instance" "Nimesa-instance" {
    ami = var.ami-id
    subnet_id = aws_subnet.Nimesa-public-subnet.id
    instance_type = var.instance-type
    availability_zone = "eu-west-2a"
    vpc_security_group_ids = [aws_security_group.Nimesa-sg.id] 
        tags = {
        purpose = "assignment"
        Name = "Nimesa-instance"
    }    
 }   


#Creating new volume of ec2 instance
resource "aws_ebs_volume" "Nimesa-volume" {
    size = 5
    type = "gp2"
    availability_zone = "eu-west-2a"
}

#Attaching the new created volume
resource "aws_volume_attachment" "volumne-attachment" {
    volume_id = aws_ebs_volume.Nimesa-volume.id
    instance_id = aws_instance.Nimesa-instance.id
    device_name = "/dev/sdf"
}
#Creating Security group

resource "aws_security_group" "Nimesa-sg" {
    description = "security-group-for-EC2-instance"
    vpc_id = aws_vpc.Nimesa-assignment-vpc.id
    name = "Nimesa-sg"
    ingress {
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Nimesa-SG"
    }
}

#By default outbound traffic allow all so need to mention egress rule according to our scenario.


variable "vpc-cidr" {
    default = "10.0.0.0/16"
}

variable "public-subnet" {
    default = "10.0.1.0/24"
}

variable "private-subnet" {
    default = "10.0.2.0/24"
}

variable "ami-id" {
    default = "ami-07fb9d5c721566c65"
}

variable "instance-type" {
    default = "t2.micro"
}


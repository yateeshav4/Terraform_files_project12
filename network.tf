resource "aws_internet_gateway" "jenkins-igw" {
    vpc_id = aws_vpc.jenkins-vpc.id
    tags = {
        Name = "jenkins-igw"
    }
}
# Define a route table for the public subnet
resource "aws_route_table" "public-jenkins-rt" {
    vpc_id = aws_vpc.jenkins-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.jenkins-igw.id
    }

    tags = {
        Name = "public-jenkins-rt"
    }
}
# Associate the public subnet with the public route table.
resource "aws_route_table_association" "public-subnet-association" {
    subnet_id      = aws_subnet.public-jenkins-subnet.id
    route_table_id = aws_route_table.public-jenkins-rt.id
}

# Create a new security group
resource "aws_security_group" "jenkins-sg" {
  description = "Allows port SSH, HTTP, and Jenkins traffic"
  vpc_id      = aws_vpc.jenkins-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}

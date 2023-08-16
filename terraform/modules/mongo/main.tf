
resource "aws_vpc" "terraform-mongo-vpc" {
  cidr_block = var.cidr_blocks
  tags = {
  Name : "${var.env_prefix}-vpc" }
}

resource "aws_subnet" "terraform-mongo-subnet-1" {
  vpc_id            = aws_vpc.terraform-mongo-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}
# create a new route table
resource "aws_route_table" "terraform-mongo-route-table" {
  vpc_id = aws_vpc.terraform-mongo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-mongo-igw.id
  }
  tags = {
    Name : "${var.env_prefix}-rtb"
  }
}
# create a internet gateway for the VPC
resource "aws_internet_gateway" "terraform-mongo-igw" {
  vpc_id = aws_vpc.terraform-mongo-vpc.id
  tags = {
    Name : "${var.env_prefix}-rtb"
  }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.terraform-mongo-subnet-1.id
  route_table_id = aws_route_table.terraform-mongo-route-table.id
}
resource "aws_security_group" "terraform-mongo-sg" {
  name   = "terraform-mongo-sg"
  vpc_id = aws_vpc.terraform-mongo-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22 # a range, from 22 to 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # list of IP address allowed to access the server
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name : "${var.env_prefix}-sg"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = var.public_key
}

# resource "aws_key_pair" "ssh_key_machine" {
#   key_name   = "ssh_key_machine"
#   public_key = file("~/.ssh/id_rsa.pub")
# }



resource "aws_instance" "terraform-mongo-server" {
  ami = var.image_name
  # create the instance
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.terraform-mongo-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.terraform-mongo-sg.id]
  availability_zone           = var.avail_zone
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  tags = {
    Name : "${var.env_prefix}-server"
  }
}

resource "local_file" "hosts_mongo" {
  depends_on = [aws_instance.terraform-mongo-server]
  content = templatefile("modules/mongo/templates/host.tpl",
    {
      host = aws_instance.terraform-mongo-server.public_ip
    }
  )
  filename = "../ansible/inventory/hosts.yaml"
}

# resource "null_resource" "ansible" {
#   depends_on = [local_file.hosts_mongo]
#   provisioner "local-exec" {
#     working_dir = "ansible"
#     command     = "ansible-playbook -i inventory/hosts.yaml ngnix.yaml"
#   }
# }


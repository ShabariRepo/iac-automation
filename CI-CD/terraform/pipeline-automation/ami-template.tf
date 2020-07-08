data "aws_ami" "jenkins-master" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-master-2.107.1"]
  }
}

data "aws_ami" "jenkins-slave" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-slave-1"]
  }
}

data "aws_ami" "nexus" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["nexus-3.24.0-02"]
  }
}
data "aws_ami" "bastion1" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["bastion-2018.03.0"] // bastion-20200128 bastion-20190927 old deprecated bastion-2018.03.0"]
  }
}

resource "aws_key_pair" "tomcatOracleSample_key_pair" {
  key_name = "tomcatOracleSample_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
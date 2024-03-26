locals {
  vpc_cidr = "192.100.0.0/16"
  private_subnet = {
    cidr : "192.100.0.0/24",
    subnet_name : "private_subnet"
  }
  public_subnet = {
    cidr : "192.100.1.0/24",
    subnet_name : "public_subnet"
  }
}

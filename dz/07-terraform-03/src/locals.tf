locals {
  env = "develop"
  project = "platform"
  role1 = "web"
  role2 = "db"
  ssh-keys_and_serial-port-enable = {
    ssh-keys = "${file("~/.ssh/id_rsa")}"
    serial-port-enable = 1
  }
}
### vars
variable "vm_db_os" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS"
}
variable "vm_db_resource_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Resource platform_id"
}
### netology-develop-platform-db
data "yandex_compute_image" "vm_db_ubuntu" {
  family = var.vm_db_os
}
variable "vm_db_resources" {
  type = map(any)
  default = {
    "cores" = 2
    "memory" = 2
    "core_fraction" = 20
  }
}
resource "yandex_compute_instance" "vm_db_platform" {
  name        = local.vm_db_resource_name
  platform_id = var.vm_db_resource_platform_id
  resources {
    cores         = "${var.vm_db_resources["cores"]}"
    memory        = "${var.vm_db_resources["memory"]}"
    core_fraction = "${var.vm_db_resources["core_fraction"]}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

 metadata = "${var.ssh-keys_and_serial-port-enable}"
}
variable "vms" {
  type = list(object(
    {
      name               = string
      cores              = number
      memory             = number
      size               = number
      core_fraction      = number
  }))
  default = [
     {
      name             = "netology-develop-platform-web-0"
      cores            = 2
      memory           = 4
      size             = 5
      core_fraction    = 20
    },
    {
      name             = "netology-develop-platform-web-1"
      cores            = 4
      memory           = 8
      size             = 10
      core_fraction    = 5
    }    
  ]
}

data "yandex_compute_image" "ubuntu_web" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "web" {
  depends_on = [resource.yandex_compute_instance.dev]
  for_each = toset(keys({for i, r in var.vms:  i => r}))
  platform_id = "standard-v1"
  name = var.vms[each.value]["name"]

  resources {
    cores = var.vms[each.value]["cores"]
    memory = var.vms[each.value]["memory"]
    core_fraction = var.vms[each.value]["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vms[each.value]["size"]
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = "${local.ssh-keys_and_serial-port-enable}"
}

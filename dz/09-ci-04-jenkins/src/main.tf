resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "centos" {
  family = "centos-7"
}
resource "yandex_compute_instance" "jenkins-master-01" {
  name        = "jenkins-master-01"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "sergo:${var.vms_ssh_root_key}"
  }

}
resource "yandex_compute_instance" "jenkins-agent-01" {
  name        = "jenkins-agent-01"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "sergo:${var.vms_ssh_root_key}"
  }

}

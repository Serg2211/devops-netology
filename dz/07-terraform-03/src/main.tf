resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_compute_disk" "disk" {
  count    = 3
  name     = "disk-${count.index}"
  type     = "network-nvme"
  zone     = "ru-central1-a"
  size     = 1
}

resource "yandex_compute_instance" "test" {
depends_on = [resource.yandex_compute_disk.disk]
name = "netology-develop-platform-test-1"
platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  secondary_disk {
    disk_id = resource.yandex_compute_disk.disk[0].id
  }
  secondary_disk {
    disk_id = resource.yandex_compute_disk.disk[1].id
  }
  secondary_disk {
    disk_id = resource.yandex_compute_disk.disk[2].id
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

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",

    {
    webservers =  yandex_compute_instance.dev[0].network_interface[0].nat_ip_address
    webservers =  yandex_compute_instance.dev[1].network_interface[0].nat_ip_address
    webservers =  yandex_compute_instance.web[0].network_interface[0].nat_ip_address
    webservers =  yandex_compute_instance.web[1].network_interface[0].nat_ip_address
        }  )

  filename = "${abspath(path.module)}/hosts.cfg"
}
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
  type     = "network-ssd"
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

  dynamic secondary_disk {
    for_each = "${yandex_compute_disk.disk.*.id}"

    content {
      disk_id = yandex_compute_disk.disk["${secondary_disk.key}"].id
      auto_delete = true
    }

 }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = "${local.ssh-keys_and_serial-port-enable}"
}

resource "local_file" "hosts_cfg" {
  depends_on = [resource.yandex_compute_instance.dev, resource.yandex_compute_instance.web, resource.yandex_compute_instance.test ]
  content = templatefile("${path.module}/hosts.tftpl",

    { webservers =  yandex_compute_instance.web,
      dev = yandex_compute_instance.dev,
      test = [yandex_compute_instance.test]
    }

  )
  filename = "${abspath(path.module)}/hosts.cfg"
}

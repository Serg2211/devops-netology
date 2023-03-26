# Домашнее задание к занятию 7.3 «Управляющие конструкции в коде Terraform»  

### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars
3. Инициализируйте проект, выполните код (он выполнится даже если доступа к preview нет).

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-03/dz/07-terraform-03/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; width: 400px">


<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-03/dz/07-terraform-03/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нем создание двух **одинаковых** виртуальных машин с минимальными параметрами, используя мета-аргумент **count loop**.

```bash
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "dev" {
count = 2
name = "netology-develop-platform-dev-${count.index}"
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
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = "${var.ssh-keys_and_serial-port-enable}"
}
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-03/dz/07-terraform-03/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

2. Создайте файл for_each-vm.tf. Опишите в нем создание 2 **разных** по cpu/ram/disk виртуальных машин, используя мета-аргумент **for_each loop**. Используйте переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.

```bash
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
      name             = "netology-develop-platform-web1"
      cores            = 2
      memory           = 4
      size             = 5
      core_fraction    = 20
    },
    {
      name             = "netology-develop-platform-web2"
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

  metadata = "${var.ssh-keys_and_serial-port-enable}"
}
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-03/dz/07-terraform-03/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.

```bash
resource "yandex_compute_instance" "web" {
  depends_on = [resource.yandex_compute_instance.dev]
```

4. Используйте функцию file в local переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ №2.

В файл **locals.tf** добавил:

```bash
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
```
Изменил в фалах **for_each-vm.tf** и **count-vm.tf** metadata с var на local:

```bash
  metadata = "${local.ssh-keys_and_serial-port-enable}"
```
После **terraform apply** во всех машинах получил вывод ключа:

```bash
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = <<-EOT
                -----BEGIN OPENSSH PRIVATE KEY-----
                b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
                NhAAAAAwEAAQAAAYEA4UK9w/1VD/jPfwrEXoRj7bkNuhQcYPl5IUx30gRtX3cwtIpWOiqg
                .....
```

5. Инициализируйте проект, выполните код.

**depends_on** отработал:

```bash
yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 1s [id=enpvajs3uuieh85di89p]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_security_group.example: Creating...
yandex_vpc_subnet.develop: Creation complete after 1s [id=e9b2iu6bidac622nutlt]
yandex_compute_instance.dev[1]: Creating...
yandex_compute_instance.dev[0]: Creating...
yandex_vpc_security_group.example: Creation complete after 2s [id=enpctj9u4tcpjcb0lvml]
yandex_compute_instance.dev[0]: Still creating... [10s elapsed]
yandex_compute_instance.dev[1]: Still creating... [10s elapsed]
yandex_compute_instance.dev[0]: Still creating... [20s elapsed]
yandex_compute_instance.dev[1]: Still creating... [20s elapsed]
yandex_compute_instance.dev[0]: Still creating... [30s elapsed]
yandex_compute_instance.dev[1]: Still creating... [30s elapsed]
yandex_compute_instance.dev[0]: Creation complete after 34s [id=fhmcdulf460qu1haiqg3]
yandex_compute_instance.dev[1]: Creation complete after 37s [id=fhmj1rtl9for66ns4v6g]
yandex_compute_instance.web["1"]: Creating...
yandex_compute_instance.web["0"]: Creating...
yandex_compute_instance.web["1"]: Still creating... [10s elapsed]
yandex_compute_instance.web["0"]: Still creating... [10s elapsed]
yandex_compute_instance.web["1"]: Still creating... [20s elapsed]
yandex_compute_instance.web["0"]: Still creating... [20s elapsed]
yandex_compute_instance.web["1"]: Still creating... [30s elapsed]
yandex_compute_instance.web["0"]: Still creating... [30s elapsed]
yandex_compute_instance.web["1"]: Creation complete after 32s [id=fhmfsqm9go5h6mih9f8i]
yandex_compute_instance.web["0"]: Creation complete after 33s [id=fhm9l052l4pg6jndv66t]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
sergo@ubuntu-pc:~/7.3/src$ 
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-03/dz/07-terraform-03/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска, размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count.

```bash
resource "yandex_compute_disk" "default" {
  count = 3
  name     = "disk-${count.index}"
  type     = "network-nvme"
  zone     = "ru-central1-a"
  size = 1
}
```

2. Создайте одну **любую** ВМ. Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

Пробовал разными путями, но так и не смог сделать через **dynamic secondary_disk{..}**, подключил явно указав (прошу дать развернутое объяснение, можно с примером):

```bash
  secondary_disk {
    disk_id = resource.yandex_compute_disk.disk[0].id
  }
  secondary_disk {
    disk_id = resource.yandex_compute_disk.disk[1].id
  }
  secondary_disk {
    disk_id = resource.yandex_compute_disk.disk[2].id
  }
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-03/dz/07-terraform-03/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; width: 400px">


3. Назначьте ВМ созданную в 1-м задании группу безопасности.

Как назначить группу безопасности? Просто указать ту же сеть? Если да, то у всех ВМ указана сеть **develop**, на которой настроена группа безопасности **example_dynamic**

```bash
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
```

------

### Задание 4

1. Создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/demonstration2).
Передайте в него в качестве переменных имена и внешние ip-адреса ВМ из задания 2.1 и 2.2.

Знаю, что не правильно, т.к. ниже получил ошибку

```bash
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
```

2. Выполните код. Приложите скриншот получившегося файла.

Получил ошибку, хотя ip  получены, но я так понял в файл они не сохранены... Строковое значение не может использоваться в словаре с циклом for... Могу сказать только одно - map, list, циклы и т.п. мне после этого занятия совсем не понятны.

```bash
│ Error: Error in function call
│ 
│   on main.tf line 56, in resource "local_file" "hosts_cfg":
│   56:   content = templatefile("${path.module}/hosts.tftpl",
│   57:     {
│   58:     webservers =  yandex_compute_instance.dev[0].network_interface[0].nat_ip_address
│   59:     webservers =  yandex_compute_instance.dev[1].network_interface[0].nat_ip_address
│   60:     webservers =  yandex_compute_instance.web[0].network_interface[0].nat_ip_address
│   61:     webservers =  yandex_compute_instance.web[1].network_interface[0].nat_ip_address
│   62:         }  )
│     ├────────────────
│     │ while calling templatefile(path, vars)
│     │ path.module is "."
│     │ yandex_compute_instance.dev[0].network_interface[0].nat_ip_address is "158.160.37.190"
│     │ yandex_compute_instance.dev[1].network_interface[0].nat_ip_address is "51.250.79.66"
│     │ yandex_compute_instance.web[0].network_interface[0].nat_ip_address is "158.160.46.120"
│     │ yandex_compute_instance.web[1].network_interface[0].nat_ip_address is "84.201.158.41"
│ 
│ Call to function "templatefile" failed: ./hosts.tftpl:3,14-24: Iteration over non-iterable value; A value of type string cannot be used as the collection in a 'for' expression..
╵
sergo@ubuntu-pc:~/7.3/src$ 

```


Для общего зачета создайте в вашем GitHub репозитории новую ветку terraform-03. Закомитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

### Правила приема работы

В своём git-репозитории создайте новую ветку terraform-03, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-03.

В качестве результата прикрепите ссылку на ветку terraform-03 в вашем репозитории.

ВАЖНО!Удалите все созданные ресурсы.

### Критерии оценки

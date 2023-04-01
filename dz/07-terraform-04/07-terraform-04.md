# Домашнее задание к занятию 7.4 «Продвинутые методы работы с Terraform»  

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания ВМ с помощью remote модуля.
2. Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменную для ssh ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание что ssh-authorized-keys принимает в себя список, а не строку!

```bash
module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = yandex_vpc_network.develop.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.develop.id ]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }

}

data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = var.ssh_public_key
  }
}

```

```bash
variable "ssh_public_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3N......jrJ6rvMIyeke95HjM0hy5CiR"
}
```

3. Добавьте в файл cloud-init.yml установку nginx.

```bash
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_public_key}
package_update: false
package_upgrade: false
packages:
  - nginx
  - mc
final_message:
  - "Container initialisation complete."
```
final_message не увидел =(

4. Предоставьте скриншот подключения к консоли и вывод команды ```nginx -t```.

```bash
sergo@ubuntu-pc:~/7.4/demonstration1$ ssh ubuntu@51.250.2.245
The authenticity of host '51.250.2.245 (51.250.2.245)' can't be established.
ED25519 key fingerprint is SHA256:8FsgcdOU3zXUVBEgj650APcJJAOU52HborPow3128Z0.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.2.245' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-137-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@develop-web-0:~$ nginx -v
nginx version: nginx/1.18.0 (Ubuntu)
ubuntu@develop-web-0:~$ nginx -t
nginx: [alert] could not open error log file: open() "/var/log/nginx/error.log" failed (13: Permission denied)
2023/03/31 18:46:13 [warn] 2477#2477: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:1
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
2023/03/31 18:46:13 [emerg] 2477#2477: open() "/run/nginx.pid" failed (13: Permission denied)
nginx: configuration file /etc/nginx/nginx.conf test failed
ubuntu@develop-web-0:~$ 
```
<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-04/dz/07-terraform-03/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-04/dz/07-terraform-03/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля. например: ```ru-central1-a```.

vpc/main.tf

```bash
resource "yandex_vpc_network" "develop_vpc" {
  name = var.vpc_name
  description    = "vpc description"

  labels = var.labels
}
resource "yandex_vpc_subnet" "develop_vpc_subnet" {
  for_each = var.subnets

  name           = each.key
  zone           = each.value.zone
  network_id     = yandex_vpc_network.develop_vpc.id
  v4_cidr_blocks = [each.value.cidr]
  description    = "vpc description"

  labels = var.labels
}
```
vpc/variables.tf

```bash
variable "vpc_name" {
  type    = string
  default = "vpc"
  description = "vpc description"
}

variable "subnets" {
  description    = "vpc_subnets description"
  type = map(object({
    zone = string
    cidr = string
  }))
}

variable "labels" {
  type        = map(string)
  description = "Labels to mark resources."
  default     = {}
}
```

2. Модуль должен возвращать значения vpc.id и subnet.id

vpc/outputs.tf

```bash
output "vpc_id" {
  description = "vpc_id"
  value       = yandex_vpc_network.develop_vpc.id
}

output "subnets_locations" {
  description = "subnets_locations"
  value       = zipmap(values(yandex_vpc_subnet.develop_vpc_subnet)[*].name, values(yandex_vpc_subnet.develop_vpc_subnet)[*].id)
}
```
```bash
sergo@ubuntu-pc:~/7.4/src$ terraform refresh
module.vpc.yandex_vpc_network.develop_vpc: Refreshing state... [id=enpvt1hfabb9h8e08ukc]
module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]: Refreshing state... [id=e9bdqrpr3ff2jqep9cmt]
sergo@ubuntu-pc:~/7.4/src$ 
```

3. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем.

main.tf

```bash
module "vpc" {
  source  = "./vpc"


  subnets = {
    public-ru-central1-a  = { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  }

  labels = {
    owner       = "sergo"
    project     = "netology_test_vpc"
    environment = "test"
  }
}
```

4. Сгенерируйте документацию к модулю с помощью terraform-docs.    
 
README.md:
```md
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.develop_vpc](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.develop_vpc_subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to mark resources. | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | vpc\_subnets description | <pre>map(object({<br>    zone = string<br>    cidr = string<br>  }))</pre> | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | vpc description | `string` | `"vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets_locations"></a> [subnets\_locations](#output\_subnets\_locations) | subnets\_locations |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | vpc\_id |
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-04/dz/07-terraform-03/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

### Задание 3
1. Выведите список ресурсов в стейте.

```bash
sergo@ubuntu-pc:~/7.4/src$ terraform state list
module.vpc.yandex_vpc_network.develop_vpc
module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]
sergo@ubuntu-pc:~/7.4/src$ 
```

2. Удалите из стейта модуль vpc.

```bash
sergo@ubuntu-pc:~/7.4/src$ terraform state rm module.vpc
Removed module.vpc.yandex_vpc_network.develop_vpc
Removed module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]
Successfully removed 2 resource instance(s).
sergo@ubuntu-pc:~/7.4/src$ 
```

3. Импортируйте его обратно. Проверьте terraform plan - изменений быть не должно.
Приложите список выполненных команд и вывод.

```bash
sergo@ubuntu-pc:~/7.4/src$ terraform import 'module.vpc.yandex_vpc_network.develop_vpc' enpvt1hfabb9h8e08ukc
module.vpc.yandex_vpc_network.develop_vpc: Importing from ID "enpvt1hfabb9h8e08ukc"...
module.vpc.yandex_vpc_network.develop_vpc: Import prepared!
  Prepared yandex_vpc_network for import
module.vpc.yandex_vpc_network.develop_vpc: Refreshing state... [id=enpvt1hfabb9h8e08ukc]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

sergo@ubuntu-pc:~/7.4/src$ terraform import 'module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]' e9bdqrpr3ff2jqep9cmt
module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]: Importing from ID "e9bdqrpr3ff2jqep9cmt"...
module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]: Import prepared!
  Prepared yandex_vpc_subnet for import
module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]: Refreshing state... [id=e9bdqrpr3ff2jqep9cmt]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

sergo@ubuntu-pc:~/7.4/src$ terraform plan
module.vpc.yandex_vpc_network.develop_vpc: Refreshing state... [id=enpvt1hfabb9h8e08ukc]
module.vpc.yandex_vpc_subnet.develop_vpc_subnet["public-ru-central1-a"]: Refreshing state... [id=e9bdqrpr3ff2jqep9cmt]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
sergo@ubuntu-pc:~/7.4/src$ 
```

### Правила приема работы

В своём git-репозитории создайте новую ветку terraform-04, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

ВАЖНО!Удалите все созданные ресурсы.

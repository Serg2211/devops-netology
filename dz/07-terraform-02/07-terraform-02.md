# Домашнее задание к занятию 7.2 «Основы Terraform. Yandex Cloud»  

### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.

```text
Изучил
```

2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**

```text
Файл подготовил
```

3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.

```text
Ключ сгеририровал и скопировал в файл
```

4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?

```bash
- Finding latest version of yandex-cloud/yandex...
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider yandex-cloud/yandex: could not connect to registry.terraform.io: failed to request discovery document: Get
│ "https://registry.terraform.io/.well-known/terraform.json": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
```

Были какие то проблемы с поиском провайдера. Перенастроил все по инструкции с сайта cloud.yandex.ru. Плюс VPN:

```bash
nano ~/.terraformrc
Добавьте в него следующий блок:

provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
Было так - required_version = ">=0.13"
Возможно ошибка была из-за пробела:

```bash
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "<зона доступности по умолчанию>"
}
```
```bash
sergo@ubuntu-pc:~/7.2/src$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Installing yandex-cloud/yandex v0.87.0...
- Installed yandex-cloud/yandex v0.87.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
sergo@ubuntu-pc:~/7.2/src$ 
```
Далее появилась следующая проблема:

```bash
rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
```
Некорректное количество ядер. Исправил:

```bash
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
```

```bash
  Enter a value: yes

yandex_compute_instance.platform: Creating...
yandex_compute_instance.platform: Still creating... [10s elapsed]
yandex_compute_instance.platform: Still creating... [21s elapsed]
yandex_compute_instance.platform: Still creating... [31s elapsed]
yandex_compute_instance.platform: Creation complete after 38s [id=fhmvt3pi32jp5huv0881]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
sergo@ubuntu-pc:~/7.2/src$ 
```

5. Ответьте, что означает ```preemptible = true``` и ```core_fraction``` в параметрах ВМ? Как это может пригодится в процессе обучения? Ответ в документации Yandex cloud.

```preemptible = true``` - Enables VMs preemption for autoscaling compute subcluster - Включает преимущественное использование виртуальных машин для автоматического масштабирования вычислительного подкластера.

```core_fraction``` - Baseline level of CPU performance with the ability to burst performance above that baseline level. This field sets baseline performance for each core - Базовый уровень производительности процессора с возможностью увеличения производительности выше этого базового уровня. Это поле задает базовую производительность для каждого ядра. Например, если нужно всего 5% производительности процессора, можно установить core_fraction=5.

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-02/dz/07-terraform-02/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; width: 300px">

- скриншот успешного подключения к консоли ВМ через ssh,

```bash
Connecting to 158.160.41.112:22...
Connection established.
To escape to local shell, press 'Ctrl+Alt+]'.

Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-137-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

/usr/bin/xauth:  file /home/ubuntu/.Xauthority does not exist
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@fhm503gbkq4s60km8s24:~$ 
```

### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.

```bash
sergo@ubuntu-pc:~/7.2/src$ cat main.tf 
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_os
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_resource_name
  platform_id = var.vm_web_resource_platform_id
  resources {
    cores         = var.vm_web_resource_cores
    memory        = var.vm_web_resource_memory
    core_fraction = var.vm_web_resource_core_fraction
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

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
sergo@ubuntu-pc:~/7.2/src$ 
```

2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 

```bash
sergo@ubuntu-pc:~/7.2/src$ cat variables.tf 
###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###new vars
variable "vm_web_os" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS"
}

variable "vm_web_resource_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Resource name"
}

variable "vm_web_resource_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Resource platform_id"
}

variable "vm_web_resource_cores" {
  type        = number
  default     = 2
  description = "Number of processor cores"
}

variable "vm_web_resource_memory" {
  type        = number
  default     = 2
  description = "Number of RAM"
}

variable "vm_web_resource_core_fraction" {
  type        = number
  default     = 5
  description = "Baseline performance for each core"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 ........."
  description = "ssh-keygen -t ed25519"
}
sergo@ubuntu-pc:~/7.2/src$ 
```

3. Проверьте terraform plan (изменений быть не должно). 

```bash
sergo@ubuntu-pc:~/7.2/src$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enp5r1qj24h5gsdkpglt]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8snjpoq85qqv0mk9gi]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b0ilf2c4ghfte65d12]
yandex_compute_instance.platform: Refreshing state... [id=fhm503gbkq4s60km8s24]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
sergo@ubuntu-pc:~/7.2/src$ 
```

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные ВМ.

```bash
sergo@ubuntu-pc:~/7.2/src$ cat vms_platform.tf 
### vars
variable "vm_db_os" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS"
}

variable "vm_db_resource_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Resource name"
}

variable "vm_db_resource_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Resource platform_id"
}

variable "vm_db_resource_cores" {
  type        = number
  default     = 2
  description = "Number of processor cores"
}

variable "vm_db_resource_memory" {
  type        = number
  default     = 2
  description = "Number of RAM"
}

variable "vm_db_resource_core_fraction" {
  type        = number
  default     = 20
  description = "Baseline performance for each core"
}

variable "vm_db_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 ........"
  description = "ssh-keygen -t ed25519"
}

### netology-develop-platform-db
data "yandex_compute_image" "vm_db_ubuntu" {
  family = var.vm_db_os
}
```

2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле.

```bash
sergo@ubuntu-pc:~/7.2/src$ cat vms_platform.tf 
### vars
...

### netology-develop-platform-db
data "yandex_compute_image" "vm_db_ubuntu" {
  family = var.vm_db_os
}

resource "yandex_compute_instance" "vm_db_platform" {
  name        = var.vm_db_resource_name
  platform_id = var.vm_db_resource_platform_id
  resources {
    cores         = var.vm_db_resource_cores
    memory        = var.vm_db_resource_memory
    core_fraction = var.vm_db_resource_core_fraction
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

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vm_db_ssh_root_key}"
  }

}sergo@ubuntu-pc:~/7.2/src$ 
```

3. Примените изменения.

```bash
      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_compute_instance.vm_db_platform: Creating...
yandex_compute_instance.vm_db_platform: Still creating... [10s elapsed]
yandex_compute_instance.vm_db_platform: Still creating... [20s elapsed]
yandex_compute_instance.vm_db_platform: Still creating... [30s elapsed]
yandex_compute_instance.vm_db_platform: Creation complete after 30s [id=fhmt760aqaa5vqdbhd9c]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
sergo@ubuntu-pc:~/7.2/src$ 
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-02/dz/07-terraform-02/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; width: 300px">

```bash
Connecting to 158.160.52.175:22...
Connection established.
To escape to local shell, press 'Ctrl+Alt+]'.

Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-137-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

/usr/bin/xauth:  file /home/ubuntu/.Xauthority does not exist
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@fhmt760aqaa5vqdbhd9c:~$ 
```

### Задание 4

1. Объявите в файле outputs.tf отдельные output, для каждой из ВМ с ее внешним IP адресом.
```bash
output "platform_ip_address" {
value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
description = "platform external ip"
}

output "vm_db_platform_ip_address" {
value = yandex_compute_instance.vm_db_platform.network_interface.0.nat_ip_address
description = "vm_db external ip"
}
```

2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```

```bash
sergo@ubuntu-pc:~/7.2/src$ terraform apply
yandex_vpc_network.develop: Refreshing state... [id=enp5r1qj24h5gsdkpglt]
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.vm_db_ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8snjpoq85qqv0mk9gi]
data.yandex_compute_image.vm_db_ubuntu: Read complete after 1s [id=fd8snjpoq85qqv0mk9gi]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b0ilf2c4ghfte65d12]
yandex_compute_instance.vm_db_platform: Refreshing state... [id=fhmt760aqaa5vqdbhd9c]
yandex_compute_instance.platform: Refreshing state... [id=fhm503gbkq4s60km8s24]

Changes to Outputs:
  + platform_ip_address       = "158.160.41.112"
  + vm_db_platform_ip_address = "158.160.52.175"

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

platform_ip_address = "158.160.41.112"
vm_db_platform_ip_address = "158.160.52.175"
sergo@ubuntu-pc:~/7.2/src$ 
```

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию по примеру из лекции.

Файл locals.tf:

```bash
locals {
  env = "develop"
  project = "platform"
  role1 = "web"
  role2 = "db"
}
```
Файл main.tf:
```bash
...
resource "yandex_compute_instance" "platform" {
  name        = "netology–${ local.env }–${ local.project }–${ local.role1 }"
  ...
```
Файл vms_platform.tf:
```bash
resource "yandex_compute_instance" "vm_db_platform" {
  name        = "netology–${ local.env }–${ local.project }–${ local.role2 }"
```

2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.

```bash
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_resource_name
```
```bash
resource "yandex_compute_instance" "vm_db_platform" {
  name        = local.vm_db_resource_name
```

3. Примените изменения.

```bash
sergo@ubuntu-pc:~/7.2/src$ terraform apply
data.yandex_compute_image.vm_db_ubuntu: Reading...
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enp5r1qj24h5gsdkpglt]
data.yandex_compute_image.vm_db_ubuntu: Read complete after 0s [id=fd8snjpoq85qqv0mk9gi]
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8snjpoq85qqv0mk9gi]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b0ilf2c4ghfte65d12]
yandex_compute_instance.vm_db_platform: Refreshing state... [id=fhmt760aqaa5vqdbhd9c]
yandex_compute_instance.platform: Refreshing state... [id=fhm503gbkq4s60km8s24]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

platform_ip_address = "158.160.41.112"
vm_db_platform_ip_address = "158.160.52.175"
sergo@ubuntu-pc:~/7.2/src$ 
```


### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".

В variables.tf:

```bash
variable "vm_web_resources" {
  type = map(any)
  default = {
    "cores" = 2
    "memory" = 2
    "core_fraction" = 5
  }
}
```
В main.tf:

```bash
  resources {
    cores         = "${var.vm_web_resources["cores"]}"
    memory        = "${var.vm_web_resources["memory"]}"
    core_fraction = "${var.vm_web_resources["core_fraction"]}"
  }
```
В vms_platform.tf:

```bash
variable "vm_db_resources" {
  type = map(any)
  default = {
    "cores" = 2
    "memory" = 2
    "core_fraction" = 20
  }
}


  resources {
    cores         = "${var.vm_db_resources["cores"]}"
    memory        = "${var.vm_db_resources["memory"]}"
    core_fraction = "${var.vm_db_resources["core_fraction"]}"
  }
```

2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.

```bash
variable "ssh-keys_and_serial-port-enable" {
  type = map(any)
  default = {
    "ssh-keys" = "ubuntu:ssh-ed25519 ..."
    "serial-port-enable" = 1
  }
}
```
В файлах main.tf и vms_platform.tf заменил переменные, связанные с ssh и serial-port следующей строчкой:

```bash
 metadata = "${var.ssh-keys_and_serial-port-enable}"
```

3. Найдите и удалите все более не используемые переменные проекта.

```text
Удалил все не используемые переменные
```

4. Проверьте terraform plan (изменений быть не должно).

```bash
sergo@ubuntu-pc:~/7.2/src$ terraform apply
data.yandex_compute_image.vm_db_ubuntu: Reading...
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enp5r1qj24h5gsdkpglt]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8snjpoq85qqv0mk9gi]
data.yandex_compute_image.vm_db_ubuntu: Read complete after 1s [id=fd8snjpoq85qqv0mk9gi]
yandex_vpc_subnet.develop: Refreshing state... [id=e9b0ilf2c4ghfte65d12]
yandex_compute_instance.platform: Refreshing state... [id=fhm503gbkq4s60km8s24]
yandex_compute_instance.vm_db_platform: Refreshing state... [id=fhmt760aqaa5vqdbhd9c]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

platform_ip_address = "158.160.41.112"
vm_db_platform_ip_address = "158.160.52.175"
sergo@ubuntu-pc:~/7.2/src$ 
```

------


### Правила приема работы

В git-репозитории, в котором было выполнено задание к занятию "Введение в Terraform", создайте новую ветку terraform-02, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-02.

В качестве результата прикрепите ссылку на ветку terraform-02 в вашем репозитории.

**ВАЖНО!Удалите все созданные ресурсы**.

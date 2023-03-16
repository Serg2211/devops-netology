# Домашнее задание к занятию 7.1 «Введение в Terraform»  


### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform**(не менее 1.3.7). Приложите скриншот вывода команды ```terraform --version```

```bash
sergo@ubuntu-pc:~$ terraform --version
Terraform v1.4.0
on linux_amd64
sergo@ubuntu-pc:~$ 
```

2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.

```bash
sergo@ubuntu-pc:~/7.1/src$ ls -a
.  ..  .gitignore  main.tf  terraformrc
sergo@ubuntu-pc:~/7.1/src$ 
```

3. Убедитесь, что в вашей ОС установлен docker

```bash
sergo@ubuntu-pc:~$ docker -v
Docker version 23.0.1, build a5ee5b1
sergo@ubuntu-pc:~$ 
```

------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 

```bash
sergo@ubuntu-pc:~/7.1/src$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 3.0.1"...
- Finding latest version of hashicorp/random...
- Installing kreuzwerker/docker v3.0.1...
- Installed kreuzwerker/docker v3.0.1 (self-signed, key ID BD080C4571C6104C)
- Installing hashicorp/random v3.4.3...
- Installed hashicorp/random v3.4.3 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
sergo@ubuntu-pc:~/7.1/src$ 
```

2. Изучите файл **.gitignore**. В каком terraform файле допустимо сохранить личную, секретную информацию?

```bash
# own secret vars store.
personal.auto.tfvars
```

3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**. Пришлите его в качестве ответа.

```bash
"result": "c18AUA5V5vwly0Tx"
```

```bash
{
  "version": 4,
  "terraform_version": "1.4.0",
  "serial": 1,
  "lineage": "60aba224-e859-edb1-147b-f67214c923ec",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "random_password",
      "name": "random_string",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"]",
      "instances": [
        {
          "schema_version": 3,
          "attributes": {
            "bcrypt_hash": "$2a$10$1G9MDOrm4fuyxrtcwRLR8.iOwIM3p4WfbrdPTUE.u5GewkrsFSmjW",
            "id": "none",
            "keepers": null,
            "length": 16,
            "lower": true,
            "min_lower": 1,
            "min_numeric": 1,
            "min_special": 0,
            "min_upper": 1,
            "number": true,
            "numeric": true,
            "override_special": null,
            "result": "c18AUA5V5vwly0Tx",
            "special": false,
            "upper": true
          },
          "sensitive_attributes": []
        }
      ]
    }
  ],
  "check_results": null
}

```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**.
Выполните команду ```terraform -validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.

```bash
│ Error: Missing name for resource
│ 
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
```
```bash
# Имя ресурса должно содержать 2 метки (ниже код, который привел к ошибке)
resource "docker_image" {
  name         = "nginx:latest"
  keep_locally = true
}
```

```bash
│ Error: Invalid resource name
│ 
│   on main.tf line 29, in resource "docker_container" "1nginx":
│   29: resource "docker_container" "1nginx" {
│ 
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
```
```bash
# Имя ресурса должно начинаться с буквы или символа подчеркивания и может содержать только буквы, цифры, знаки подчеркивания и тире (ниже код, который привел к ошибке)
resource "docker_container" "1nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 8000
  }
}
```
```bash
│ Error: Reference to undeclared resource
│ 
│   on main.tf line 30, in resource "docker_container" "nginx":
│   30:   image = docker_image.nginx.image_id
│ 
│ A managed resource "docker_image" "nginx" has not been declared in the root module.
```
```bash
# Ресурс "docker_image" "nginx" не был объявлен в корневом модуле (ниже код, который привел к ошибке)
resource "docker_image" "nginx-last" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 8000
  }
}
```
```bash
# Код без ошибок
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=0.13" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {}

#однострочный комментарий

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "nginx-last" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx-last.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 8000
  }
}
```
5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
root@ubuntu-pc:/home/sergo/7.1/src# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
a833532e4fd0   904b8cb13b93   "/docker-entrypoint.…"   21 seconds ago   Up 20 seconds   0.0.0.0:8000->80/tcp   example_c18AUA5V5vwly0Tx
root@ubuntu-pc:/home/sergo/7.1/src# 

```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```.

```bash
Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
root@ubuntu-pc:/home/sergo/7.1/src# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
a0717558aedc   904b8cb13b93   "/docker-entrypoint.…"   11 seconds ago   Up 11 seconds   0.0.0.0:8000->80/tcp   hello_world
root@ubuntu-pc:/home/sergo/7.1/src# 

```

Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ? 

```text
Команда apply применила все изменения автоматически. Если случайно установить не правильные данные, то они бы применились. Следствием может быть все что угодно, вплоть до полной поломки всей инфраструктуры. Полезно проверять код перед apply раза 2-3.
```

7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 

```bash
docker_container.nginx: Destroying... [id=a0717558aedc6de3f8ae9d6300e935b833fdaa38634da69c285c5434d16a9e23]
random_password.random_string: Destroying... [id=none]
random_password.random_string: Destruction complete after 0s
docker_container.nginx: Destruction complete after 1s
docker_image.nginx-last: Destroying... [id=sha256:904b8cb13b932e23230836850610fa45dce9eb0650d5618c2b1487c2a4f577b8nginx:latest]
docker_image.nginx-last: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
root@ubuntu-pc:/home/sergo/7.1/src# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@ubuntu-pc:/home/sergo/7.1/src# docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    904b8cb13b93   2 weeks ago   142MB
root@ubuntu-pc:/home/sergo/7.1/src# 
```

8. Объясните, почему при этом не был удален docker образ **nginx:latest** ?(Ответ найдите в коде проекта или документации)

```bash
resource "docker_image" "nginx-last" {
  name         = "nginx:latest"
  keep_locally = true
}
```
```text
Скорее всего команда keep_locally = true сохранила образ в локальные образы Docker.
```

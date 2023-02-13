# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"  

Задача 1.  

Сценарий выполения задачи:  

создайте свой репозиторий на <https://hub.docker.com>;  
выберете любой образ, который содержит веб-сервер Nginx;  
создайте свой fork образа;  
реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:  

Создаем страницу  

```bash
sergo@sergo-vb:~$ touch index.html
sergo@sergo-vb:~$ nano index.html
```

содержащей HTML  

```html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

собираем образ

```bash
sergo@sergo-vb:~$ docker build -t new-d/nginx .
Sending build context to Docker daemon  49.66kB
Step 1/2 : FROM nginx:latest
 ---> a99a39d070bf
Step 2/2 : COPY ./index.html /usr/share/nginx/html/index.html
 ---> a6c36016faf1
Successfully built a6c36016faf1
Successfully tagged new-d/nginx:latest
sergo@sergo-vb:~$ 
```

проверка

```bash
sergo@sergo-vb:~$ 
sergo@sergo-vb:~$ docker run -it -d -p 8080:80 --name nginx new-d/nginx
45b1e276764e9df868f0fad8027a4c9db78a7c9aec90c205aae3aa6256815b51
sergo@sergo-vb:~$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS         PORTS                                   NAMES
45b1e276764e   new-d/nginx   "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   nginx
sergo@sergo-vb:~$ curl localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
sergo@sergo-vb:~$ 
```

Загрузка в репозитарий

```nash
sergo@sergo-vb:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED          SIZE
new-d/nginx   latest    a6c36016faf1   28 minutes ago   142MB
nginx         latest    a99a39d070bf   8 days ago       142MB
ubuntu        latest    6b7dfa7e8fdb   5 weeks ago      77.8MB
hello-world   latest    feb5d9fea6a5   16 months ago    13.3kB
sergo@sergo-vb:~$ docker tag a6c36016faf1 new-d/nginx:1.0
sergo@sergo-vb:~$ docker push new-d/nginx:1.0
The push refers to repository [docker.io/new-d/nginx]
c1d838cd8c23: Preparing 
80115eeb30bc: Preparing 
049fd3bdb25d: Preparing 
ff1154af28db: Preparing 
8477a329ab95: Preparing 
7e7121bf193a: Waiting 
67a4178b7d47: Waiting 
denied: requested access to the resource is denied
....
```

Тут мне помог мануал с сайта докера (хотелось бы лекциях больше информации)  
Tag your private images with your newly created Docker ID using:  
docker tag namespace1/docker101tutorial new_namespace/docker101tutorial  

```bash
sergo@sergo-vb:~$ docker tag new-d/nginx:1.0 sergo2211/first-repo:1.0
sergo@sergo-vb:~$ docker push sergo2211/first-repo:1.0
The push refers to repository [docker.io/sergo2211/first-repo]
c1d838cd8c23: Pushed 
80115eeb30bc: Pushed 
049fd3bdb25d: Pushed 
ff1154af28db: Pushed 
8477a329ab95: Pushed 
7e7121bf193a: Pushed 
67a4178b7d47: Pushed 
1.0: digest: sha256:570f9d861ecdd5c569e59b49a1c97dcb9dfcd73dfabdb40b631ff879804e6356 size: 1777
sergo@sergo-vb:~$ 
```

Ссылка

<https://hub.docker.com/repository/docker/sergo2211/first-repo/general>

Задача 2.

Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"  

Детально опишите и обоснуйте свой выбор.  

Сценарий:  

Высоконагруженное монолитное java веб-приложение;  С java не работал, но насколько знаю (могу ошибаться), требовательно к ресурсам. Я бы использовал физический сервер.  

Nodejs веб-приложение;  Изучив интернет, пришел к выводу - Использование Docker, позволяет оптимизировать процесс разработки и вывода в продакшн Node.js-проектов.  

Мобильное приложение c версиями для Android и iOS;  В разработке приложений Docker используют в основном энтузиасты, и то с Android приложениями, с учетом закрытости iOS? там все еще сложнее.  

Шина данных на базе Apache Kafka;   Можно создавать кластер из множества хостов с фрагментированным топиком. Хосты можно убирать, добавлять, все при этом легко масштабируется.  

Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;  Мы запускаем Elasticsearch на VM, kibana и logstash, думаю, можно поднять в Docker.  

Мониторинг-стек на базе Prometheus и Grafana;  Докер подойдет  

MongoDB, как основное хранилище данных для java-приложения;  Существует много методик контейнеризации приложений, основанных на React, Node.js и MongoDB с использованием Docker.  

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. Тут возможна смешанная система.  

Задача 3.

```bash
sergo@sergo-vb:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                      PORTS     NAMES
627cc0d642ff   centos        "/bin/bash"              5 seconds ago    Up 5 seconds                          amazing_williams
a33da711f4f6   debian        "bash"                   27 seconds ago   Up 26 seconds                         brave_gagarin
```

Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;  

```bash
sergo@sergo-vb:~$ docker run -d -v /data:/data centos
e8305714712ca9aefd624f7e491887bf95153ef96c1c6d8f68297718bb931178
```

Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;

```bash
sergo@sergo-vb:~$ docker run -d -v /data:/data debian
aaf1c1d6070bd3b0a38839d578710532abc5ff1a4f783aea8849e5ead7216d3f
```

Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;

```bash
sergo@sergo-vb:~$ docker exec -it amazing_williams bash
[root@627cc0d642ff /]# touch /data/new_file2.txt
[root@627cc0d642ff /]# exit
exit
```

Добавьте еще один файл в папку /data на хостовой машине;

```bash
sergo@sergo-vb:~$ sudo touch /data/new_file222.txt
```

Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.  

```bash
sergo@sergo-vb:~$ docker exec -it brave_gagarin bash
root@a33da711f4f6:/# ls
bin  boot  data  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@a33da711f4f6:/# cd /data
root@a33da711f4f6:/data# ls
new_file2.txt  new_file222.txt
root@a33da711f4f6:/data# 
```

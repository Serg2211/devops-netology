Домашнее задание к занятию "10.3 Система сбора логов Elastic Stack»  

**Задание 1**

Вам необходимо поднять в докере и связать между собой:

- elasticsearch (hot и warm ноды);
- logstash;
- kibana;
- filebeat.

Logstash следует сконфигурировать для приёма по tcp json-сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](./help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения этого задания.

Результатом выполнения задания должны быть:

- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5);
- скриншот интерфейса kibana;

```bash
root@ubuntu-pc:/home/sergo/help# docker-compose up -d
Creating network "help_elastic" with driver "bridge"
Creating network "help_default" with the default driver
Creating some_app ... done
Creating es-warm  ... done
Creating es-hot   ... done
Creating logstash ... done
Creating kibana   ... done
Creating filebeat ... done
root@ubuntu-pc:/home/sergo/help# docker ps
CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS         PORTS                                                                                            NAMES
18612319e2ba   elastic/filebeat:8.7.0   "/usr/bin/tini -- /u…"   6 minutes ago   Up 6 minutes                                                                                                    filebeat
2168006a79d3   kibana:8.7.0             "/bin/tini -- /usr/l…"   6 minutes ago   Up 6 minutes   0.0.0.0:5601->5601/tcp, :::5601->5601/tcp                                                        kibana
5a0e38453b2c   logstash:8.7.0           "/usr/local/bin/dock…"   6 minutes ago   Up 6 minutes   0.0.0.0:5044->5044/tcp, :::5044->5044/tcp, 0.0.0.0:5046->5046/tcp, :::5046->5046/tcp, 9600/tcp   logstash
731d9e05be50   elasticsearch:8.7.0      "/bin/tini -- /usr/l…"   6 minutes ago   Up 6 minutes   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 9300/tcp                                              es-hot
d5a8cada1e62   python:3.9-alpine        "python3 /opt/run.py"    6 minutes ago   Up 6 minutes                                                                                                    some_app
2bf4a200efea   elasticsearch:8.7.0      "/bin/tini -- /usr/l…"   6 minutes ago   Up 6 minutes   9200/tcp, 9300/tcp                                                                               es-warm
root@ubuntu-pc:/home/sergo/help# 
```
<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-03-elk/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-03-elk/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">



## Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create) и создайте несколько index-patterns из имеющихся.

Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите, как отображаются логи и как производить поиск по логам.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-03-elk/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-03-elk/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">
---

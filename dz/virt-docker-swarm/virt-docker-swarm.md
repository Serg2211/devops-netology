# Домашнее задание к занятию "5.5 Оркестрация кластером Docker контейнеров на примере Docker Swarm"  

Задача 1.

Дайте письменые ответы на следующие вопросы:  

В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?  (из документации)  

global - это режим, который запускает одну задачу на каждом узле. Заранее заданного количества заданий нет.  

replication - в этом режиме вы указываете количество идентичных задач, которые хотите запустить. Количество задач на нодах может быть различным.  

Какой алгоритм выбора лидера используется в Docker Swarm кластере?  

Узлы Docker Swarm кластера используют алгоритм консенсуса Raft для управления состоянием кластера. Своего рода согласованные выборы.  

Количество управляющих узлов не ограничено. В случае сбоя работы лидера (например, перезагрузка), выбирается новый лидер большинство менеджеров, также называемое кворумом.  

Что такое Overlay Network?  

Внутренняя частная сеть, которая охватывает все узлы, участвующие в кластере swarm. Таким образом, оверлейные сети облегчают обмен данными между сервисом Docker Swarm и автономным контейнером или между двумя автономными контейнерами на разных демонах Docker.  

Задача 2.

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке  

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

```bash
docker node ls
```

```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
n5oqqby8joy9cd43a1gcefsry *   node01.netology.yc   Ready     Active         Leader           20.10.23
hzyumz6tude1vpo20syg2vlne     node02.netology.yc   Ready     Active         Reachable        20.10.23
m0mhobgg294twdqfcpemr1crx     node03.netology.yc   Ready     Active         Reachable        20.10.23
zaf3taqzduzvoo1gd2spojn61     node04.netology.yc   Ready     Active                          20.10.23
n3vbmauoyz8u55g5v8l0volsy     node05.netology.yc   Ready     Active                          20.10.23
dwb0c6xgchruzxikrs0g17q8w     node06.netology.yc   Ready     Active                          20.10.23
[centos@node01 ~]$ 
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/virt-docker-swarm/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 300px">

Задача 3.

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.  

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:  

```bash
docker service ls
```

```bash
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
c64gjsn5ad4l   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
au4ddild0wl9   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
qs3gxypv2bhr   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
seho4cl0yeqz   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
s43fm4lumydl   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
7558a56ql6bb   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
ml2b0ufccd3s   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
jh7damihybd7   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
[centos@node01 ~]$ 
```
  
<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/virt-docker-swarm/images/2-2.png"
  alt="image 2-2.png"
  title="image 2-2.png"
  style="display: inline-block; margin: 0 auto; max-width: 300px">
  
Задача 4.

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:

Журналы Raft, используемые менеджерами Docker Swarm кластера, по умолчанию зашифрованы на диске. Это шифрование в состоянии покоя защищает конфигурацию и данные вашего сервиса от злоумышленников.

```bash
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

```bash
[centos@node01 ~]$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-...

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```

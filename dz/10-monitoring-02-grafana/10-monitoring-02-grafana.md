Домашнее задание к занятию "10.2 Средство визуализации Grafana»  

**Задание повышенной сложности**

Задание 1

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

Через [terraform](https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/src/main.tf) поднял 3 VM: grafana-server, node-01, node-02:

```bash
sergo@ubuntu-pc:~/10.2/src$ terraform apply
...
...
...
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

grafana-server_ip_address = "158.160.110.34"
node-01_ip_address = "51.250.79.189"
node-02_ip_address = "158.160.109.16"
sergo@ubuntu-pc:~/10.2/src$
```
<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


Передал в ansible конфиг [prometheus.yml](https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/infrastructure/site.yml):

```yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'grafana-server'
    scrape_interval: 5s
    static_configs:
      - targets: ['158.160.110.34:9100']
  - job_name: 'node-01'
    scrape_interval: 5s
    static_configs:
      - targets: ['51.250.79.189:9100']
  - job_name: 'node-02'
    scrape_interval: 5s
    static_configs:
      - targets: ['158.160.109.16:9100']
```

Через [ansible](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085) установил на grafana-server: Grafana и Prometheus, на все 3 VM установил: Node Exporter и другой нужный мне софт

```bash
sergo@ubuntu-pc:~/10.2/infrastructure$ ansible-playbook -i ./inventory/cicd/hosts.yml site.yml

PLAY [all] **********************************************************************************************************************************************************************************************************************************************

TASK [Install soft to all VM] ***************************************************************************************************************************************************************************************************************************
changed: [node-01]
changed: [grafana-server]
changed: [node-02]

PLAY [server] *******************************************************************************************************************************************************************************************************************************************

TASK [download Grafana] *********************************************************************************************************************************************************************************************************************************
[WARNING]: Consider using the get_url or uri module rather than running 'wget'.  If you need to use command because get_url or uri is insufficient you can add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get
rid of this message.
changed: [grafana-server]

TASK [install Grafana] **********************************************************************************************************************************************************************************************************************************
changed: [grafana-server]

TASK [Start the grafana-server service] *****************************************************************************************************************************************************************************************************************
changed: [grafana-server]

PLAY [metrics] ******************************************************************************************************************************************************************************************************************************************

TASK [Download Node Exporter] ***************************************************************************************************************************************************************************************************************************
changed: [node-01]
changed: [grafana-server]
changed: [node-02]

TASK [Extract Node Exporter] ****************************************************************************************************************************************************************************************************************************
[WARNING]: Consider using the unarchive module rather than running 'tar'.  If you need to use command because unarchive is insufficient you can add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get rid of this
message.
changed: [node-01]
changed: [node-02]
changed: [grafana-server]

TASK [Create Node Exporter User] ************************************************************************************************************************************************************************************************************************
changed: [node-01]
changed: [node-02]
changed: [grafana-server]

TASK [Create the Node Exporter service] *****************************************************************************************************************************************************************************************************************
changed: [node-01]
changed: [node-02]
changed: [grafana-server]

TASK [Start the Node Exporter service] ******************************************************************************************************************************************************************************************************************
changed: [node-02]
changed: [node-01]
changed: [grafana-server]

PLAY [server] *******************************************************************************************************************************************************************************************************************************************

TASK [Create Prometheus system group] *******************************************************************************************************************************************************************************************************************
changed: [grafana-server]

TASK [Create data & configs directories] ****************************************************************************************************************************************************************************************************************
[WARNING]: Consider using the file module with state=directory rather than running 'mkdir'.  If you need to use command because file is insufficient you can add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to
get rid of this message.
changed: [grafana-server]

TASK [Download Prometheus files] ************************************************************************************************************************************************************************************************************************
changed: [grafana-server]

TASK [Create Prometheus configuration template] *********************************************************************************************************************************************************************************************************
changed: [grafana-server]

TASK [Change directory permissions] *********************************************************************************************************************************************************************************************************************
changed: [grafana-server]

TASK [Create the Prometheus service] ********************************************************************************************************************************************************************************************************************
changed: [grafana-server]

TASK [Start the Prometheus service] *********************************************************************************************************************************************************************************************************************
changed: [grafana-server]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
grafana-server             : ok=16   changed=16   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node-01                    : ok=6    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node-02                    : ok=6    changed=6    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/10.2/infrastructure$ 
```
**Итог**

Cкриншот веб-интерфейса grafana со списком подключенных Datasource:

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


Установлен Dashboards Node Exporter Full (выбор VM для мониторинга на скриншоте):

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

Пример node-02:

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


[src](https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/src)

[infrastructure](https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/infrastructure)

Задание 2


Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);

```
avg by(instance)(rate(node_cpu_seconds_total{job="grafana-server",mode="idle"}[$__rate_interval])) * 100
```
- CPULA 1/5/15;

```
avg by (instance)(rate(node_load1{job="grafana-server"}[$__rate_interval]))
```

```
avg by (instance)(rate(node_load5{job="grafana-server"}[$__rate_interval]))
```

```
avg by (instance)(rate(node_load15{job="grafana-server"}[$__rate_interval]))
```

- количество свободной оперативной памяти;

```
avg by (instance)(rate(node_load5{job="grafana-server"}[$__rate_interval]))
```

- количество места на файловой системе.

```
node_filesystem_size_bytes{job="grafana-server",mountpoint="/"}
node_filesystem_avail_bytes{job="grafana-server",mountpoint="/"}
```

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/7.png"
  alt="image 7.png"
  title="image 7.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/images/8.png"
  alt="image 8.png"
  title="image 8.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

[new_dashboard.json](https://github.com/Serg2211/devops-netology/blob/main/dz/10-monitoring-02-grafana/new_dashboard.json)

# Домашнее задание к занятию "6.4 PostgreSQL""  

Задача 1.

Cоставьте Dockerfile-манифест для elasticsearch.

Будет ли считаться ошибкой, если я выполнил задание через docker-compose? За пример взял файл из видеолекции, доработал под требования задания. Привожу docker-compose.yaml

```yaml
version: '3.9'
services:

  elasticsearch:
    image: elasticsearch:7.14.2
    container_name: elasticsearch
    environment:
      - node.name=netology_test
      - xpack.security.enabled=false
      - discovery.type=single-node
    volumes:
      - es-data:/var/lib/es-data
    networks:
      - elasticsearch-net
    ports:
      - 9200:9200
      - 9300:9300
    restart: always

  kibana:
    depends_on:
      - elasticsearch
    image: kibana:7.14.2
    container_name: kibana
    environment:
      - ELACTICSEARCH_HOSTS=http://elasticsearch:9200
    volumes:
      - kb-data:/var/lib/kb-data
    networks:
      - elasticsearch-net
    ports:
      - 5601:5601
    restart: always

networks:
  elasticsearch-net:
    driver: bridge

volumes:
  es-data:
    driver: local
  kb-data:
    driver: local
```
Cоберите docker-образ и сделайте push в ваш docker.io репозиторий

```bash
sergo@sergo-vb:~/6$ docker images
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
centos          latest    5d0da3dc9764   17 months ago   231MB
elasticsearch   7.14.2    2abd5342ace0   17 months ago   1.04GB
kibana          7.14.2    750d302f8aff   17 months ago   1.29GB
sergo@sergo-vb:~/6$ 
```
```bash
sergo@sergo-vb:~/6$ docker-compose start
[+] Running 2/2
 ⠿ Container elasticsearch  Started                                                                                                                                                                                    0.2s
 ⠿ Container kibana         Started                                                                                                                                                                                    0.2s
sergo@sergo-vb:~/6$ docker-compose ps
NAME                IMAGE                  COMMAND                  SERVICE             CREATED             STATUS              PORTS
elasticsearch       elasticsearch:7.14.2   "/bin/tini -- /usr/l…"   elasticsearch       2 minutes ago       Up 11 seconds       0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp
kibana              kibana:7.14.2          "/bin/tini -- /usr/l…"   kibana              2 minutes ago       Up 11 seconds       0.0.0.0:5601->5601/tcp, :::5601->5601/tcp
sergo@sergo-vb:~/6$ 
```
соберите docker-образ и сделайте push в ваш docker.io репозиторий

[ссылка](https://hub.docker.com/repository/docker/sergo2211/elasticsearch/general)

запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины

```bash
sergo@sergo-vb:~/6$ curl localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "F30cbYZzTnOD4WKMSx8QRw",
  "version" : {
    "number" : "7.14.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "6bc13727ce758c0e943c3c21653b3da82f627f75",
    "build_date" : "2021-09-15T10:18:09.722761972Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
sergo@sergo-vb:~/6$ 
```

Задача 2.

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```bash
sergo@sergo-vb:~/6$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"} 
sergo@sergo-vb:~/6$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"} 
sergo@sergo-vb:~/6$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"} 
```
Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```bash
sergo@sergo-vb:~/6$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index                           uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases                muF4UTaYSFq90QEe2yasLw   1   0         41            0     39.6mb         39.6mb
green  open   .apm-custom-link                jTs5cLPsSsmID7Rtdrjo5w   1   0          0            0       208b           208b
green  open   .kibana_task_manager_7.14.2_001 7Z1qUxBqSAGmlwc534IQiQ   1   0         14         3588    568.4kb        568.4kb
green  open   .apm-agent-configuration        89cyyNWLQXKjs4zg_M6CNg   1   0          0            0       208b           208b
green  open   ind-1                           0g418BWTT4mgwqx-qAxM5g   1   0          0            0       208b           208b
green  open   .kibana_7.14.2_001              gmBCpxjzSPSkWRfcCzpPHA   1   0         14            0      2.3mb          2.3mb
yellow open   ind-3                           -mmQhTvkRTK4Qguju65Kmg   4   2          0            0       832b           832b
green  open   .kibana-event-log-7.14.2-000001 HU5CparvTmSJFoJNn1wNNg   1   0          2            0       11kb           11kb
green  open   .tasks                          F1nJcxaQSN2X3_35OA21Hw   1   0          2            0     13.7kb         13.7kb
yellow open   ind-2                           EKG6gabVT-uZm_GY3CdRNw   2   1          0            0       416b           416b
sergo@sergo-vb:~/6$ 
```

```bash
sergo@sergo-vb:~/6$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
sergo@sergo-vb:~/6$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 60.0
}
sergo@sergo-vb:~/6$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 60.0
}
sergo@sergo-vb:~/6$ 
```
Получите состояние кластера `elasticsearch`, используя API.

```bash
sergo@sergo-vb:~/6$ curl -X GET 'http://localhost:9200/_cluster/health/?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 15,
  "active_shards" : 15,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 60.0
}
sergo@sergo-vb:~/6$ 
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

В системе из одного сервера elasticsearch хранит на нём все “primary shards”, но создавать “replica shards” такой системе негде. Поэтому статус является жёлтым из-за ненулевого значения “unassigned_shards”, которое примерно равно “active_shards”.

Удалите все индексы.

```bash
sergo@sergo-vb:~/6$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
sergo@sergo-vb:~/6$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
sergo@sergo-vb:~/6$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
sergo@sergo-vb:~/6$ curl -X GET 'http://localhost:9200/_cluster/health/?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
sergo@sergo-vb:~/6$ 
```
Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

```bash
sergo@sergo-vb:~/6$ docker exec -it elasticsearch /bin/bash
[root@7db522f235dd elasticsearch]# which elasticsearch
/usr/share/elasticsearch/bin/elasticsearch
[root@7db522f235dd elasticsearch]# pwd
/usr/share/elasticsearch
[root@7db522f235dd elasticsearch]# mkdir snapshots
[root@7db522f235dd elasticsearch]# ls
bin  config  data  jdk	lib  LICENSE.txt  logs	modules  NOTICE.txt  plugins  README.asciidoc  snapshots
```



Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

Сначало ничего не получилось, подсказка в конце задания помогола:

```bash
[root@7db522f235dd elasticsearch]# cd config/
[root@7db522f235dd config]# ls
elasticsearch.keystore	elasticsearch.yml  jvm.options	jvm.options.d  log4j2.file.properties  log4j2.properties  role_mapping.yml  roles.yml  users  users_roles
[root@7db522f235dd config]# nano elasticsearch.yml 
```
Есть предположение, что это все можно было бы сделать через docker-compose, добавить в environment.

```bash
...
path.repo: ["/usr/share/elasticsearch/snapshots"]
```

```bash
sergo@sergo-vb:~/6$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d' { "type": "fs", "settings": { "location": "/usr/share/elasticsearch/snapshots"}}'
{
  "error" : {
    "root_cause" : [
      {
        "type" : "exception",
        "reason" : "failed to create blob container"
        ...
```
Интернет пришел на помощь

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```bash
[root@7db522f235dd elasticsearch]# chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots
[root@7db522f235dd elasticsearch]# exit
exit
sergo@sergo-vb:~/6$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d' { "type": "fs", "settings": { "location": "/usr/share/elasticsearch/snapshots"}}'
{
  "acknowledged" : true
}
sergo@sergo-vb:~/6$ 
```



Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash
sergo@sergo-vb:~/6$  curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d' {"settings": {"number_of_shards": 1, "number_of_replicas": 0}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
sergo@sergo-vb:~/6$ curl 'localhost:9200/_cat/indices?v'
health status index                           uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases                muF4UTaYSFq90QEe2yasLw   1   0         41           33     39.6mb         39.6mb
green  open   .apm-custom-link                jTs5cLPsSsmID7Rtdrjo5w   1   0          0            0       208b           208b
green  open   test                            HmDniFYZRCaHu60T-PHJ1g   1   0          0            0       208b           208b
green  open   .kibana_task_manager_7.14.2_001 7Z1qUxBqSAGmlwc534IQiQ   1   0         14         1170    513.6kb        513.6kb
green  open   .apm-agent-configuration        89cyyNWLQXKjs4zg_M6CNg   1   0          0            0       208b           208b
green  open   .kibana_7.14.2_001              gmBCpxjzSPSkWRfcCzpPHA   1   0         15            4      2.3mb          2.3mb
green  open   .tasks                          F1nJcxaQSN2X3_35OA21Hw   1   0          6            0     28.9kb         28.9kb
green  open   .kibana-event-log-7.14.2-000001 HU5CparvTmSJFoJNn1wNNg   1   0          4            0     21.8kb         21.8kb
sergo@sergo-vb:~/6$ 
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```bash
sergo@sergo-vb:~/6$ curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "hPHegyXfSpuoI8P2HHw_uA",
    "repository" : "netology_backup",
    "version_id" : 7140299,
    "version" : "7.14.2",
    "indices" : [
      "test",
      ".apm-custom-link",
      ".kibana_task_manager_7.14.2_001",
      ".apm-agent-configuration",
      ".tasks",
      ".ds-ilm-history-5-2023.02.24-000001",
      ".kibana-event-log-7.14.2-000001",
      ".kibana_7.14.2_001",
      ".geoip_databases"
    ],
    "data_streams" : [
      "ilm-history-5"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2023-02-25T15:01:01.647Z",
    "start_time_in_millis" : 1677337261647,
    "end_time" : "2023-02-25T15:01:02.649Z",
    "end_time_in_millis" : 1677337262649,
    "duration_in_millis" : 1002,
    "failures" : [ ],
    "shards" : {
      "total" : 9,
      "failed" : 0,
      "successful" : 9
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      },
      {
        "feature_name" : "kibana",
        "indices" : [
          ".kibana_task_manager_7.14.2_001",
          ".kibana_7.14.2_001",
          ".apm-agent-configuration",
          ".apm-custom-link"
        ]
      },
      {
        "feature_name" : "tasks",
        "indices" : [
          ".tasks"
        ]
      }
    ]
  }
}
sergo@sergo-vb:~/6$ 
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```bash
sergo@sergo-vb:~/6$ docker exec -it elasticsearch /bin/bash
[root@7db522f235dd elasticsearch]# cd snapshots/
[root@7db522f235dd snapshots]# ls
index-0  index.latest  indices	meta-hPHegyXfSpuoI8P2HHw_uA.dat  snap-hPHegyXfSpuoI8P2HHw_uA.dat
[root@7db522f235dd snapshots]#
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
sergo@sergo-vb:~/6$ curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d' {"settings": {"number_of_shards": 1, "number_of_replicas": 0}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
sergo@sergo-vb:~/6$ curl 'localhost:9200/_cat/indices?v'
health status index                           uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2                          BtCzvx4ZT1CEYDDqklSrjA   1   0          0            0       208b           208b
green  open   .geoip_databases                muF4UTaYSFq90QEe2yasLw   1   0         41           33     39.6mb         39.6mb
green  open   .apm-custom-link                jTs5cLPsSsmID7Rtdrjo5w   1   0          0            0       208b           208b
green  open   .kibana_task_manager_7.14.2_001 7Z1qUxBqSAGmlwc534IQiQ   1   0         14          360    351.9kb        351.9kb
green  open   .apm-agent-configuration        89cyyNWLQXKjs4zg_M6CNg   1   0          0            0       208b           208b
green  open   .kibana_7.14.2_001              gmBCpxjzSPSkWRfcCzpPHA   1   0         15            4      2.3mb          2.3mb
green  open   .kibana-event-log-7.14.2-000001 HU5CparvTmSJFoJNn1wNNg   1   0          4            0     21.8kb         21.8kb
green  open   .tasks                          F1nJcxaQSN2X3_35OA21Hw   1   0          6            0     28.9kb         28.9kb
sergo@sergo-vb:~/6$ 
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

Получил ошибки при восстановлении

```bash
{
  "error" : {
    "root_cause" : [
      {
        "type" : "snapshot_restore_exception",
        "reason" : "[netology_backup:snapshot_1/hPHegyXfSpuoI8P2HHw_uA] cannot restore index [.ds-ilm-history-5-2023.02.24-000001] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
      }
    ],
    "type" : "snapshot_restore_exception",
    "reason" : "[netology_backup:snapshot_1/hPHegyXfSpuoI8P2HHw_uA] cannot restore index [.ds-ilm-history-5-2023.02.24-000001] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
  },
  "status" : 500
}
```
Беглый перевод дал понять, что восстановить все не получится, так как какие-то индексы уже существуют. Надо удалять существующие индексы либо их переименновывать, но решил пойти другим путем и восстановить один только индекс "test", нашел в интернете решение. Надеюсь правильное (по крвйней мере, оно сработало):

```bash
sergo@sergo-vb:~/6$ curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d' {"indices": "test", "include_global_state": true}'
{
  "accepted" : true
}
sergo@sergo-vb:~/6$
```

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```bash
sergo@sergo-vb:~/6$ curl 'localhost:9200/_cat/indices?v'
health status index                           uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2                          BtCzvx4ZT1CEYDDqklSrjA   1   0          0            0       208b           208b
green  open   .geoip_databases                2QDvSsvsSCOfy9_q7HgtGg   1   0         41           33     39.6mb         39.6mb
green  open   test                            BnPXKW1dTDG0UN5bwom5Xg   1   0          0            0       208b           208b
green  open   .apm-custom-link                -I7rGD_DS7uCgiw9xH4d7A   1   0          0            0       208b           208b
green  open   .apm-agent-configuration        3JXBXm2OSViTSkUy2wZ5Lw   1   0          0            0       208b           208b
green  open   .kibana_task_manager_7.14.2_001 aXvtax7OSdCXv4tjr1xhIw   1   0         14           12    261.4kb        261.4kb
green  open   .kibana_7.14.2_001              YCD5VqkCS_2LHjsHd73X_A   1   0         15            4      2.3mb          2.3mb
green  open   .kibana-event-log-7.14.2-000001 HU5CparvTmSJFoJNn1wNNg   1   0          4            0     21.8kb         21.8kb
green  open   .tasks                          b7WxjvFkRLuSrayoJEZBTA   1   0          6            0     28.9kb         28.9kb
sergo@sergo-vb:~/6$ 
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

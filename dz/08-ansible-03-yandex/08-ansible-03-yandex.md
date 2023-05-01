Домашнее задание к занятию "8.3 Использование Yandex Cloud»  


1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-04/dz/08-ansible-03-yandex/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.

Добавил в site.yml

```bash
...
- name: Install NGINX
  hosts: lighthouse
  handlers:
    - name: Nginx start
      become: true
      ansible.builtin.service:
        name: nginx
        state: started
    - name: Nginx reload
      become: true
      command: nginx -s reload
  tasks:
    - name: Install epel-release
      become: true
      ansible.builtin.yum:
        name: epel-release
        state: present
    - name: Install nginx
      become: true
      ansible.builtin.yum:
        name: nginx
        state: present
      notify: Nginx start
    - name: Create nginx config
      become: true
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        mode: 0644
      notify: Nginx reload

- name: Install lighthouse
  hosts: lighthouse
  handlers:
    - name: Nginx reload
      become: true
      command: nginx -s reload
  pre_tasks:
    - name: Lighthouse | Install git
      become: true
      ansible.builtin.yum:
        name: git
        state: present
  tasks:
    - name: Lighthouse | Clone repository
      become: true
      ansible.builtin.git:
        repo: "{{ lighthouse_url }}"
        dest: "{{ lighthouse_dir }}"
        version: master
    - name: Create Lighthouse config
      become: true
      ansible.builtin.template:
        src: lighthouse_nginx.conf.j2
        dest: /etc/nginx/conf.d/lighthouse.conf
        mode: 0644
      notify: Nginx reload
```

4. Подготовьте свой inventory-файл `prod.yml`.

```bash
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 51.250.73.117
      ansible_user: sergo

vector:
  hosts:
    vector-01:
      ansible_host: 158.160.56.253
      ansible_user: sergo

lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 158.160.47.83
      ansible_user: sergo
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
sergo@ubuntu-pc:~/8.3/playbook$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
sergo@ubuntu-pc:~/8.3/playbook$ 
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Подобные ошибки были и в прошлой домашке. Пока дистрибутив не скачан, ничего дальше не запускается...

```bash
sergo@ubuntu-pc:~/8.3/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   

sergo@ubuntu-pc:~/8.3/playbook$ 
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Красный текст при установке пугает. Но по итогу - все хорошо.

```bash
sergo@ubuntu-pc:~/8.3/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start clickhouse service] **************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *******************************************************************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Install vector packages] **************************************************************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create vector config file] ************************************************************************************************************************************************************************************************************************
--- before
+++ after: /home/sergo/.ansible/tmp/ansible-local-2094zwh55w0w/tmpfu4iqz5i/vector.yml.j2
@@ -0,0 +1,15 @@
+sources:
+  demo_logs:
+    type: demo_logs
+    format: syslog
+sinks:
+  to_clickhouse:
+    type: clickhouse
+    inputs:
+      - demo_logs
+    database: logs
+    endpoint: http://51.250.82.201:8123
+    table: vector_table
+    compression: gzip
+    healthcheck: true
+    skip_unknown_fields: true

[WARNING]: The value "0" (type int) was converted to "u'0'" (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
changed: [vector-01]

TASK [Vector systemd unit] ******************************************************************************************************************************************************************************************************************************
--- before: /usr/lib/systemd/system/vector.service
+++ after: /home/sergo/.ansible/tmp/ansible-local-2094zwh55w0w/tmpqd1_p4fl/vector.service.j2
@@ -5,18 +5,10 @@
 Requires=network-online.target
 
 [Service]
-User=vector
-Group=vector
-ExecStartPre=/usr/bin/vector validate
-ExecStart=/usr/bin/vector
-ExecReload=/usr/bin/vector validate
+User=root
+Group=root
+ExecStart=/usr/bin/vector --config /etc/vector/vector.yml
 ExecReload=/bin/kill -HUP $MAINPID
 Restart=always
-AmbientCapabilities=CAP_NET_BIND_SERVICE
-EnvironmentFile=-/etc/default/vector
-# Since systemd 229, should be in [Unit] but in order to support systemd <229,
-# it is also supported to have it here.
-StartLimitInterval=10
-StartLimitBurst=5
 [Install]
 WantedBy=multi-user.target

changed: [vector-01]

RUNNING HANDLER [Start Vector service] ******************************************************************************************************************************************************************************************************************
changed: [vector-01]

PLAY [Install NGINX] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install epel-release] *****************************************************************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Install nginx] ************************************************************************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Create nginx config] ******************************************************************************************************************************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /home/sergo/.ansible/tmp/ansible-local-2094zwh55w0w/tmpii2yhegp/nginx.conf.j2
@@ -1,13 +1,8 @@
-# For more information on configuration, see:
-#   * Official English Documentation: http://nginx.org/en/docs/
-#   * Official Russian Documentation: http://nginx.org/ru/docs/
-
-user nginx;
+user root;
 worker_processes auto;
 error_log /var/log/nginx/error.log;
 pid /run/nginx.pid;
 
-# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
 include /usr/share/nginx/modules/*.conf;
 
 events {
@@ -25,7 +20,7 @@
     tcp_nopush          on;
     tcp_nodelay         on;
     keepalive_timeout   65;
-    types_hash_max_size 4096;
+    types_hash_max_size 2048;
 
     include             /etc/nginx/mime.types;
     default_type        application/octet-stream;
@@ -34,51 +29,4 @@
     # See http://nginx.org/en/docs/ngx_core_module.html#include
     # for more information.
     include /etc/nginx/conf.d/*.conf;
-
-    server {
-        listen       80;
-        listen       [::]:80;
-        server_name  _;
-        root         /usr/share/nginx/html;
-
-        # Load configuration files for the default server block.
-        include /etc/nginx/default.d/*.conf;
-
-        error_page 404 /404.html;
-        location = /404.html {
-        }
-
-        error_page 500 502 503 504 /50x.html;
-        location = /50x.html {
-        }
-    }
-
-# Settings for a TLS enabled server.
-#
-#    server {
-#        listen       443 ssl http2;
-#        listen       [::]:443 ssl http2;
-#        server_name  _;
-#        root         /usr/share/nginx/html;
-#
-#        ssl_certificate "/etc/pki/nginx/server.crt";
-#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
-#        ssl_session_cache shared:SSL:1m;
-#        ssl_session_timeout  10m;
-#        ssl_ciphers HIGH:!aNULL:!MD5;
-#        ssl_prefer_server_ciphers on;
-#
-#        # Load configuration files for the default server block.
-#        include /etc/nginx/default.d/*.conf;
-#
-#        error_page 404 /404.html;
-#            location = /40x.html {
-#        }
-#
-#        error_page 500 502 503 504 /50x.html;
-#            location = /50x.html {
-#        }
-#    }
-
 }
-

changed: [lighthouse-01]

RUNNING HANDLER [Nginx start] ***************************************************************************************************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [Nginx reload] **************************************************************************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY [Install lighthouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] *************************************************************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Clone repository] ********************************************************************************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Create Lighthouse config] *************************************************************************************************************************************************************************************************************************
--- before
+++ after: /home/sergo/.ansible/tmp/ansible-local-2094zwh55w0w/tmpm3gyfuu3/lighthouse_nginx.conf.j2
@@ -0,0 +1,10 @@
+server {
+    listen    80;
+	server_name localhost;
+	location / {
+	
+	    root /usr/share/nginx/html/lighthouse;
+		index index.html;
+	
+	}
+}

changed: [lighthouse-01]

RUNNING HANDLER [Nginx reload] **************************************************************************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.3/playbook$ 
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
sergo@ubuntu-pc:~/8.3/playbook$ ansible-playbook -i ./inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "sergo", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "sergo", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *******************************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] **************************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create vector config file] ************************************************************************************************************************************************************************************************************************
[WARNING]: The value "0" (type int) was converted to "u'0'" (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [vector-01]

TASK [Vector systemd unit] ******************************************************************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install NGINX] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install epel-release] *****************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] ************************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Create nginx config] ******************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY [Install lighthouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] *************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Clone repository] ********************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Create Lighthouse config] *************************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.3/playbook$ 
```

```bash
sergo@ubuntu-pc:~/8.3/playbook$ ssh 51.250.73.117
[sergo@clickhouse-01 ~]$ clickhouse-client -h 127.0.0.1
ClickHouse client version 22.3.3.44 (official build).
Connecting to 127.0.0.1:9000 as user default.
Connected to ClickHouse server version 22.3.3 revision 54455.

clickhouse-01.ru-central1.internal :) 
```

```bash
sergo@ubuntu-pc:~/8.3/playbook$ ssh 158.160.56.253
[sergo@vector-01 ~]$ vector --version
vector 0.29.1 (x86_64-unknown-linux-gnu 74ae15e 2023-04-20 14:50:42.739094536)
[sergo@vector-01 ~]$ systemctl status vector
● vector.service - Vector
   Loaded: loaded (/usr/lib/systemd/system/vector.service; disabled; vendor preset: disabled)
   Active: active (running) since Пн 2023-05-01 15:29:34 UTC; 9min ago
     Docs: https://vector.dev
 Main PID: 8588 (vector)
   CGroup: /system.slice/vector.service
           └─8588 /usr/bin/vector --config /etc/vector/vector.yml
[sergo@vector-01 ~]$ 
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/terraform-04/dz/08-ansible-03-yandex/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

```text
Playbook устанавливает на хосты пакеты ПО Clickhouse, Vector и Lighthouse (плюс Nginx)

В group_vars/clickhouse/clickhouse.yml и group_vars/vector/vector.yml задаются версии ПО Clickhouse и Vector.

group_vars/clickhouse/vars.yml
 - clickhouse_version - "22.3.3.44" - версия Clickhouse
 - clickhouse_packages - clickhouse-client, clickhouse-server, clickhouse-common-static - пакеты Clickhouse для установки

group_vars/vector/vars.yml (здесь указал только версию ПО)
 - vector_version	"latest"

В group_vars/lighthouse/lighthouse.yml - указывается, где взять дистрибутив и куда установить.

В inventory/prod.yml задаются docker хосты для установки
```

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
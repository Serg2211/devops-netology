Домашнее задание к занятию "8.2 Работа с Playbook»  

Подготовьте хосты в соответствии с группами из предподготовленного playbook.

```bash
sergo@ubuntu-pc:~/8.2/playbook/group_vars$ sudo docker run --name clickhouse-01 -d pycontribs/centos:7 sleep infinity && sudo docker run --name vector-01 -d pycontribs/centos:7 sleep infinity
7f77ded59adf6febfabeb38b54c26d7ba3ee69cc068944c7941dc34cc2d81bde
3de7144ed6f311661db18b2ff8ff648c161605de39d9dca59191820e2bac29e3
sergo@ubuntu-pc:~/8.2/playbook/group_vars$ sudo docker container ps --all
CONTAINER ID   IMAGE                 COMMAND            CREATED          STATUS          PORTS     NAMES
3de7144ed6f3   pycontribs/centos:7   "sleep infinity"   13 seconds ago   Up 12 seconds             vector-01
7f77ded59adf   pycontribs/centos:7   "sleep infinity"   13 seconds ago   Up 12 seconds             clickhouse-01
sergo@ubuntu-pc:~/8.2/playbook/group_vars$ 
```
Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.

```yml
---
  clickhouse:
    hosts:
      clickhouse-01:
        ansible_connection: docker
  vector:
    hosts:
      vector-01:
        ansible_connection: docker
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

```yml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
        disable_gpg_check: true
      notify: Start clickhouse service
    - name: Flush handlers
      meta: flush_handlers
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
- name: Install Vector
  hosts: vector
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: started
      tags:
        - vector
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
        dest: "./vector-{{ vector_version }}-1.x86_64.rpm"
      tags:
        - vector
    - name: Install vector packages
      become: true
      ansible.builtin.yum:
        disable_gpg_check: true
        name: vector-latest-1.x86_64.rpm
      notify: Start vector service
      tags:
        - vector
```

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
sergo@ubuntu-pc:~/8.2/playbook$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 2 violation(s) that are fatal
yaml: truthy value should be one of [false, true] (truthy)
site.yml:54

yaml: no new line character at the end of file (new-line-at-end-of-file)
site.yml:71

You can skip specific rules or tags by adding them to your configuration file:
# .ansible-lint
warn_list:  # or 'skip_list' to silence them completely
  - yaml  # Violations reported by yamllint

Finished with 2 failure(s), 0 warning(s) on 1 files.
sergo@ubuntu-pc:~/8.2/playbook$ sergo@ubuntu-pc:~/8.2/playbook$ 
```
Исправил, осталось только предупреждение (это не ошибка), что файл yaml обрабатывается как плейбук.

```bash
sergo@ubuntu-pc:~/8.2/playbook$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
sergo@ubuntu-pc:~/8.2/playbook$ 
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Не совсем понятны мне ошибки. Сайты проверил, файлы на месте. Возможно ошибка связана с тем, что файл еще не загружен и соответственно нечего запускать...

```bash
sergo@ubuntu-pc:~/8.2/playbook$ sudo ansible-playbook -i ./inventory/prod.yml site.yml --check

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

sergo@ubuntu-pc:~/8.2/playbook$ 
```

Когда перешел к пункту 7, ошибок с clickhouse не было, но вылезла ошибка с vektor, пришлось перезапустить после исправления `--check`

```bash
sergo@ubuntu-pc:~/8.2/playbook$ sudo ansible-playbook -i ./inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **********************************************************************************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *******************************************************************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Install vector packages] **************************************************************************************************************************************************************************************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'vector-latest-1.x86_64.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'vector-latest-1.x86_64.rpm' found on system"]}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
vector-01                  : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.2/playbook$ 
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
sergo@ubuntu-pc:~/8.2/playbook$ sudo ansible-playbook -i inventory/prod.yml site.yml --diff

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

RUNNING HANDLER [Start vector service] ******************************************************************************************************************************************************************************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: host"}

NO MORE HOSTS LEFT **************************************************************************************************************************************************************************************************************************************

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.2/playbook$ sudo docker container ps --all
CONTAINER ID   IMAGE                 COMMAND            CREATED         STATUS         PORTS     NAMES
3de7144ed6f3   pycontribs/centos:7   "sleep infinity"   7 minutes ago   Up 7 minutes             vector-01
7f77ded59adf   pycontribs/centos:7   "sleep infinity"   7 minutes ago   Up 7 minutes             clickhouse-01
sergo@ubuntu-pc:~/8.2/playbook$ 
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

После второго запуска (и всех последующих) ошибок нет и вывод всегда один:

```bash
sergo@ubuntu-pc:~/8.2/playbook$ sudo ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

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

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.2/playbook$ 
```

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

```text
Playbook устанавливает на docker хосты пакеты ПО Clickhouse и Vector

В group_vars/clickhouse/vars.yml и group_vars/vector/vars.yml задаются версии ПО Clickhouse и Vector.

group_vars/clickhouse/vars.yml
 - clickhouse_version - "22.3.3.44" - версия Clickhouse
 - clickhouse_packages - clickhouse-client, clickhouse-server, clickhouse-common-static - пакеты Clickhouse для установки

group_vars/vector/vars.yml (здесь указал только версию ПО)
 - vector_version	"latest"

В inventory/prod.yml задаются docker хосты для установки

Тег vector позволяет отметить сущность Ansible для отдельного исполнения
```

```bash
sergo@ubuntu-pc:~/8.2/playbook$ sudo docker container ps --all
CONTAINER ID   IMAGE                 COMMAND            CREATED          STATUS          PORTS     NAMES
3de7144ed6f3   pycontribs/centos:7   "sleep infinity"   45 minutes ago   Up 45 minutes             vector-01
7f77ded59adf   pycontribs/centos:7   "sleep infinity"   45 minutes ago   Up 45 minutes             clickhouse-01
sergo@ubuntu-pc:~/8.2/playbook$ sudo docker exec -it 7f77ded59adf bash
[root@7f77ded59adf /]# clickhouse-server --version
ClickHouse server version 22.3.3.44 (official build).
[root@7f77ded59adf /]# exit
exit
sergo@ubuntu-pc:~/8.2/playbook$ sudo docker exec -it 3de7144ed6f3 bash
[root@3de7144ed6f3 /]# vector --version
vector 0.29.1 (x86_64-unknown-linux-gnu 74ae15e 2023-04-20 14:50:42.739094536)
[root@3de7144ed6f3 /]# exit
exit
sergo@ubuntu-pc:~/8.2/playbook$ 
```

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


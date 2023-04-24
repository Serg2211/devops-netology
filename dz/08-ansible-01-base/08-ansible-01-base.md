Домашнее задание к занятию "8.1 Введение в Ansible»  


Установите Ansible версии 2.10 или выше.

```bash
sergo@ubuntu-pc:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/sergo/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0]
sergo@ubuntu-pc:~$ 

```

Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

```bash
nano /group_vars/all/examp.yml 

---
  some_fact: all default fact
```
```bash
sergo@ubuntu-pc:~/8.1/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ sudo docker container ps --all
CONTAINER ID   IMAGE                 COMMAND            CREATED          STATUS          PORTS     NAMES
0bdd45bcd29e   pycontribs/ubuntu     "sleep infinity"   17 seconds ago   Up 14 seconds             ubuntu
df2e83515533   pycontribs/centos:7   "sleep infinity"   49 seconds ago   Up 46 seconds             centos7
sergo@ubuntu-pc:~/8.1/playbook$ 
```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ nano group_vars/deb/examp.yml 
sergo@ubuntu-pc:~/8.1/playbook$ nano group_vars/el/examp.yml 
```

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
sergo@ubuntu-pc:~/8.1/playbook$ ansible-vault encrypt group_vars/el/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
sergo@ubuntu-pc:~/8.1/playbook$ 
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
sergo@ubuntu-pc:~/8.1/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ ansible-doc
usage: ansible-doc [-h] [--version] [-v] [-M MODULE_PATH] [--playbook-dir BASEDIR] [-t {become,cache,callback,cliconf,connection,httpapi,inventory,lookup,netconf,shell,vars,module,strategy}] [-j] [-F | -l | -s | --metadata-dump] [plugin ...]

plugin documentation tool

positional arguments:
  plugin                Plugin

options:
  --metadata-dump       **For internal testing only** Dump json metadata for all plugins.
  --playbook-dir BASEDIR
                        Since this tool does not use playbooks, use this as a substitute playbook directory.This sets the relative path for many features including roles/ group_vars/ etc.
  --version             show program's version number, config file location, configured module search path, module location, executable location and exit
  -F, --list_files      Show plugin names and their source files without summaries (implies --list). A supplied argument will be used for filtering, can be a namespace or full collection name.
  -M MODULE_PATH, --module-path MODULE_PATH
                        prepend colon-separated path(s) to module library (default=~/.ansible/plugins/modules:/usr/share/ansible/plugins/modules)
  -h, --help            show this help message and exit
  -j, --json            Change output into json format.
  -l, --list            List available plugins. A supplied argument will be used for filtering, can be a namespace or full collection name.
  -s, --snippet         Show playbook snippet for specified plugin(s)
  -t {become,cache,callback,cliconf,connection,httpapi,inventory,lookup,netconf,shell,vars,module,strategy}, --type {become,cache,callback,cliconf,connection,httpapi,inventory,lookup,netconf,shell,vars,module,strategy}
                        Choose which plugin type (defaults to "module"). Available plugin types are : ('become', 'cache', 'callback', 'cliconf', 'connection', 'httpapi', 'inventory', 'lookup', 'netconf', 'shell', 'vars', 'module', 'strategy')
  -v, --verbose         verbose mode (-vvv for more, -vvvv to enable connection debugging)

See man pages for Ansible CLI options or website for tutorials https://docs.ansible.com
ERROR! Incorrect options passed
sergo@ubuntu-pc:~/8.1/playbook$ 
```

```bash
sergo@ubuntu-pc:~/8.1/playbook$ ansible-doc -t connection -l
......                                                                                                        
local                          execute on controller                                                                                                    
......
sergo@ubuntu-pc:~/8.1/playbook$ 
```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```bash
sergo@ubuntu-pc:~/8.1/playbook$ nano inventory/prod.yml

---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local

```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

Это задание немного не понял. Если сделать просто вывод, то для local определяется: [localhost] => {"msg": "all default fact"}, т.к. не определена отдельная переменная. Сделал так, но потом создал отдельную переменную для local. Ниже два вывода:

```bash
sergo@ubuntu-pc:~/8.1/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
[sudo] password for sergo: 
Vault password: 

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```
```bash
sergo@ubuntu-pc:~/8.1/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "local default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.1/playbook$ 
```

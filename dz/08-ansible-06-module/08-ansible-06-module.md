Домашнее задание к занятию "8.6 Создание собственных модулей»  

## Подготовка к выполнению

1. Создайте пустой публичный репозиторий в своём любом проекте: `my_own_collection`.

[my_own_collection](https://github.com/Serg2211/my_own_collection)

2. Скачайте репозиторий Ansible: `git clone https://github.com/ansible/ansible.git` по любому, удобному вам пути.

```bash
sergo@ubuntu-pc:~$ git clone https://github.com/ansible/ansible.git
Cloning into 'ansible'...
remote: Enumerating objects: 597050, done.
remote: Counting objects: 100% (304/304), done.
remote: Compressing objects: 100% (171/171), done.
remote: Total 597050 (delta 131), reused 246 (delta 101), pack-reused 596746
Receiving objects: 100% (597050/597050), 228.87 MiB | 9.74 MiB/s, done.
Resolving deltas: 100% (397528/397528), done.
sergo@ubuntu-pc:~$ 
```
3. Зайдите в директорию Ansible: `cd ansible`.
4. Создайте виртуальное окружение: `python3 -m venv venv`.
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении.
6. Установите зависимости `pip install -r requirements.txt`.
7. Запустите настройку окружения `. hacking/env-setup`.
8. Если все шаги прошли успешно — выйдите из виртуального окружения `deactivate`.
9. Ваше окружение настроено. Чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`.

```bash
sergo@ubuntu-pc:~/8.6/ansible$ . venv/bin/activate
(venv) sergo@ubuntu-pc:~/8.6/ansible$ pip install -r requirements.txt
Ignoring importlib_resources: markers 'python_version < "3.10"' don't match your environment
Collecting jinja2>=3.0.0
  Using cached Jinja2-3.1.2-py3-none-any.whl (133 kB)
Collecting PyYAML>=5.1
  Using cached PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (682 kB)
Collecting cryptography
  Using cached cryptography-40.0.2-cp36-abi3-manylinux_2_28_x86_64.whl (3.7 MB)
Collecting packaging
  Using cached packaging-23.1-py3-none-any.whl (48 kB)
Collecting resolvelib<1.1.0,>=0.5.3
  Downloading resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Collecting MarkupSafe>=2.0
  Using cached MarkupSafe-2.1.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting cffi>=1.12
  Using cached cffi-1.15.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (441 kB)
Collecting pycparser
  Using cached pycparser-2.21-py2.py3-none-any.whl (118 kB)
Installing collected packages: resolvelib, PyYAML, pycparser, packaging, MarkupSafe, jinja2, cffi, cryptography
Successfully installed MarkupSafe-2.1.2 PyYAML-6.0 cffi-1.15.1 cryptography-40.0.2 jinja2-3.1.2 packaging-23.1 pycparser-2.21 resolvelib-1.0.1
(venv) sergo@ubuntu-pc:~/8.6/ansible$ . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info
writing lib/ansible_core.egg-info/PKG-INFO
writing dependency_links to lib/ansible_core.egg-info/dependency_links.txt
writing entry points to lib/ansible_core.egg-info/entry_points.txt
writing requirements to lib/ansible_core.egg-info/requires.txt
writing top-level names to lib/ansible_core.egg-info/top_level.txt
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
warning: no previously-included files found matching 'docs/docsite/rst_warnings'
warning: no previously-included files found matching 'docs/docsite/rst/conf.py'
warning: no previously-included files found matching 'docs/docsite/rst/index.rst'
warning: no previously-included files found matching 'docs/docsite/rst/dev_guide/index.rst'
warning: no previously-included files matching '*' found under directory 'docs/docsite/_build'
warning: no previously-included files matching '*.pyc' found under directory 'docs/docsite/_extensions'
warning: no previously-included files matching '*.pyo' found under directory 'docs/docsite/_extensions'
adding license file 'COPYING'
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'

Setting up Ansible to run out of checkout...

PATH=/home/sergo/8.6/ansible/bin:/home/sergo/8.6/ansible/venv/bin:/home/sergo/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
PYTHONPATH=/home/sergo/8.6/ansible/test/lib:/home/sergo/8.6/ansible/lib
MANPATH=/home/sergo/8.6/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!

(venv) sergo@ubuntu-pc:~/8.6/ansible$ deactivate
sergo@ubuntu-pc:~/8.6/ansible$ 
```


## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

**Шаг 1.** В виртуальном окружении создайте новый `my_own_module.py` файл.

**Шаг 2.** Наполните его содержимым:

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        new=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['new']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
Или возьмите это наполнение [из статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

**Шаг 3.** Заполните файл в соответствии с требованиями Ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule
import os


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=False, default='text')
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    # result['original_message'] = module.params['name']
    # result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target

    if not(os.path.exists(module.params['path'])
    and os.path.isfile(module.params['path'])
    and open(module.params['path'],'r').read() == module.params['content']):
        try:
            with open(module.params['path'], 'w') as file:
                file.write(module.params['content'])
                result['changed'] = True
        except Exception as exp:
            module.fail_json(msg=f"Something gone wrong: {exp}", **result)

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['path'] == 'fail me':
        module.fail_json(msg='This is a fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```

**Шаг 4.** Проверьте module на исполняемость локально.

```bash
(venv) sergo@ubuntu-pc:~/8.6/ansible$ python -m ansible.modules.my_own_module new_test.json

{"changed": true, "invocation": {"module_args": {"path": "test_file.txt", "content": "Module work"}}}
(venv) sergo@ubuntu-pc:~/8.6/ansible$ 
```

**Шаг 5.** Напишите single task playbook и используйте module в нём.

```bash
sergo@ubuntu-pc:~/8.6/ansible$ cat single_task_playbook.yml 
---
- name: Test module
  hosts: localhost
  tasks:
  - name: Call my_own_module
    my_own_module:
      path: './test_file.txt'
      content: "Module work"
sergo@ubuntu-pc:~/8.6/ansible$ 
```

**Шаг 6.** Проверьте через playbook на идемпотентность.

```bash
sergo@ubuntu-pc:~/8.6/ansible$ ansible-playbook single_task_playbook.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] **************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Call my_own_module] *******************************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.6/ansible$ 
```

**Шаг 7.** Выйдите из виртуального окружения.

**Шаг 8.** Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`.

```bash
sergo@ubuntu-pc:~/8.6/ansible$ ansible-galaxy collection init my_own_namespace.yandex_cloud_elk
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
- Collection my_own_namespace.yandex_cloud_elk was created successfully
sergo@ubuntu-pc:~/8.6/ansible$ 
```

**Шаг 9.** В эту collection перенесите свой module в соответствующую директорию.

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/plugins/modules$ ls
my_own_module.py
```

**Шаг 10.** Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module.

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles$ ansible-galaxy role init single_task_role
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
- Role single_task_role was created successfully
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles$ ls
single_task_role
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles$ cd single_task_role && ls
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles/single_task_role$ 
```

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles/single_task_role/defaults$ cat main.yml 
---
# defaults file for single_task_role
path: './test_file.txt'
content: "Module work"
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles/single_task_role/defaults$ 
```

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles/single_task_role/tasks$ cat main.yml 
---
# tasks file for single_task_role
- name: Call my_own_module
  my_own_module:
    path: './test_file.txt'
    content: "Module work"
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk/roles/single_task_role/tasks$ 
```

**Шаг 11.** Создайте playbook для использования этой role.

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk$ cat site.yml 
---
- name: Test module
  hosts: localhost
  roles:
  - single_task_role

sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk$ 
```
Проверка

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk$ ansible-playbook site.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] **************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [single_task_role : Call my_own_module] ************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk$ 
```

**Шаг 12.** Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.

[my_own_collection](https://github.com/Serg2211/my_own_collection/tree/main/yandex_cloud_elk)

**Шаг 13.** Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

```bash
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk$ ansible-galaxy collection build
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
Created collection for my_own_namespace.yandex_cloud_elk at /home/sergo/8.6/ansible/my_own_namespace/yandex_cloud_elk/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
sergo@ubuntu-pc:~/8.6/ansible/my_own_namespace/yandex_cloud_elk$ 
```

**Шаг 14.** Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.

```bash
sergo@ubuntu-pc:~/8.6/new_dir$ ls
my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz  playbook.yml
sergo@ubuntu-pc:~/8.6/new_dir$ 
```

**Шаг 15.** Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`.

```bash
sergo@ubuntu-pc:~/8.6/new_dir$ ansible-galaxy collection install my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.yandex_cloud_elk:1.0.0' to '/home/sergo/.ansible/collections/ansible_collections/my_own_namespace/yandex_cloud_elk'
my_own_namespace.yandex_cloud_elk:1.0.0 was installed successfully
sergo@ubuntu-pc:~/8.6/new_dir$ 
```

**Шаг 16.** Запустите playbook, убедитесь, что он работает.

```bash
sergo@ubuntu-pc:~/8.6/new_dir$ ansible-playbook playbook.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become
unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test module] **************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Call my_own_module] *******************************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/8.6/new_dir$ ls
my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz  playbook.yml  test_file.txt
sergo@ubuntu-pc:~/8.6/new_dir$ 
```

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

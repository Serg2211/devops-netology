Домашнее задание к занятию "9.4 Jenkins»  

1. Создать два VM: для jenkins-master и jenkins-agent.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

2. Установить Jenkins при помощи playbook.

Не большое предисловие, возможно кто-то столкнется с такой проблемой.

К домашке подходил два раза, первый раз поднял две vm через terraform, потом выполнил playbook, с какого-то раза все установилось. Но времени в тот день на домашку не осталось, решил удалить машины.

Когда сел за домашку второй раз, Jenkins вообще ни как не устанавливался. Подключился по ssh, попробовал поставить в ручную, получил ошибку **Public key is not installed**. Переустановка ключа не помогла. Нашел решение:

[Jenkins upgrade fails on CentOS](https://issues.jenkins.io/browse/JENKINS-61998)

[решение](https://mirrors.jenkins-ci.org/redhat/)

После сразу запустил playbook и все установилось.

```bash
sergo@ubuntu-pc:~/9.4/infrastructure$ ansible-playbook -i ./inventory/cicd/hosts.yml site.yml --diff

PLAY [Preapre all hosts] ********************************************************************************************************************************************************************************************************************************
...
...

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
jenkins-agent-01           : ok=17   changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
jenkins-master-01          : ok=10   changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

sergo@ubuntu-pc:~/9.4/infrastructure$ 
```

3. Запустить и проверить работоспособность.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

4. Сделать первоначальную настройку.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

[Jenkinsfile](https://github.com/Serg2211/vector-role/blob/main/Jenkinsfile)

4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).

Запуск с параметром по умолчанию, с флагами `--check --diff

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/7.png"
  alt="image 7.png"
  title="image 7.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.

Запуск с включенным параметром **prod_run** без флагов `--check --diff

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/8.png"
  alt="image 8.png"
  title="image 8.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.

[ScriptedJenkinsfile](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/ScriptedJenkinsfile)

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/9.png"
  alt="image 9.png"
  title="image 9.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-04-jenkins/images/10.png"
  alt="image 10.png"
  title="image 10.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


P.S. Просmба не обращать внимание на разные IP в ссылках. Домашку делал несколько дней. Дважды Яндекс останавливал мои машины, а после загрузки у них были новые IP.

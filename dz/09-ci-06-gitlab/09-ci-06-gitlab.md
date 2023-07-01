Домашнее задание к занятию "9.6 GitLab»  


1. Подготовьте к работе GitLab [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers).
2. Создайте свой новый проект.
3. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).
4. Проект должен быть публичным, остальные настройки по желанию.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


**Основная часть**

**DevOps**

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. При комите в любую ветку должен собираться docker image с форматом имени hello:gitlab-$CI_COMMIT_SHORT_SHA . Образ должен быть выложен в Gitlab registry или yandex registry.   

[Dockerfile](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/repository/Dockerfile)

[gitlab-ci.yml](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/repository/gitlab-ci.yml)

[requirements.txt](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/repository/requirements.txt)

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

**Product Owner**

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

**Developer**

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.

[python-api.py](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/repository/python-api.py)

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

**Tester**

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.

```bash
[root@5882ad37ed11 /]# curl http://127.0.0.1:5290/get_info
<!doctype html>
<html lang=en>
<title>404 Not Found</title>
<h1>Not Found</h1>
<p>The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.</p>
[root@5882ad37ed11 /]# curl http://127.0.0.1:5290/rest/api/get_info
{"version": 3, "method": "GET", "message": "Running"}
[root@5882ad37ed11 /]# 
```

2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-06-gitlab/images/7.png"
  alt="image 7.png"
  title="image 7.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

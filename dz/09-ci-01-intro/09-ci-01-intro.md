Домашнее задание к занятию "9.1 Жизненный цикл ПО»  

Подготовка к выполнению

1. Получить бесплатную версию [Jira](https://www.atlassian.com/ru/software/jira/free).
2. Настроить её для своей команды разработки.
3. Создать доски Kanban и Scrum.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

## Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/images/2_1.png"
  alt="image 2_1.png"
  title="image 2_1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/images/3_1.png"
  alt="image 3_1.png"
  title="image 3_1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done. 

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/images/2_2.png"
  alt="image 2_2.png"
  title="image 2_2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

1. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/images/3_2.png"
  alt="image 3_2.png"
  title="image 3_2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

1. При проведении обеих задач по статусам используйте kanban. 
1. Верните задачи в статус Open.
1. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
2. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.

[All_workflow](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/All_workflow.xml)

[Bug_workflow](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-01-intro/Bug_workflow.xml)
# Домашнее задание к занятию "6.2 Домашнее задание к занятию "2. SQL""  

Задача 1.

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.:

```yaml
version: '3.9'

volumes:
  data: {}
  backup: {}

services:

  postgres:
    image: postgres:12
    container_name: psql
    ports:
      - "0.0.0.0:5432:5432"
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/media/postgresql/backup
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
    restart: always
```

Задача 2.  

Итоговый список БД после выполнения пунктов выше

```SQL
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

test_db=# 

```

Описание таблиц (describe)

```SQL
test_db=# \d clients
                                               Table "public.clients"
              Column               |       Type        | Collation | Nullable |               Default               
-----------------------------------+-------------------+-----------+----------+-------------------------------------
 id                                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия                           | character varying |           |          | 
 страна проживания                 | character varying |           |          | 
 заказ                             | integer           |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=#
```

```SQL
test_db=# \d orders
                                          Table "public.orders"
          Column          |       Type        | Collation | Nullable |              Default               
--------------------------+-------------------+-----------+----------+------------------------------------
 id                       | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование             | character varying |           |          | 
 цена                     | integer           |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# 

```

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

Запрос по конкретным пользователям:

```SQL
test_db=# SELECT * FROM information_schema.table_privileges WHERE grantee = 'test-admin-user' or grantee = 'test-simple-user';
```

Список пользователей с правами над таблицами test_db

```SQL
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)

test_db=# 
```

Запрос по конкретным таблицвм:

```SQL
test_db=# SELECT * FROM information_schema.table_privileges WHERE table_name = 'clients' OR table_name = 'orders';
```

Список пользователей с правами над таблицами test_db:

```SQL
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | test_db       | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | postgres         | test_db       | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(36 rows)

test_db=# 
```

Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

```SQL
test_db=# INSERT INTO orders (наименование, цена) VALUES
('Шоколад', 10),
('Принтер', 3000),
('Книга', 500),
('Монитор', 7000),
('Гитара', 4000);
INSERT 0 5
test_db=# 
```

Таблица clients

```SQL
test_db=# INSERT INTO clients (фамилия, "страна проживания") VALUES
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# 
```

Используя SQL синтаксис:

вычислите количество записей для каждой таблицы

запросы и результаты их выполнения:

```SQL
test_db=# SELECT COUNT(*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# 
```

```SQL
test_db=# SELECT COUNT(*) FROM clients;
 count 
-------
     5
(1 row)

test_db=# 
```

Задача 4.

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

```table
|          ФИО         |  Заказ  |
|:--------------------:|:-------:|
| Иванов Иван Иванович | Книга   |
| Петров Петр Петрович | Монитор |
| Иоганн Себастьян Бах | Гитара  |
```

Приведите SQL-запросы для выполнения данных операций.

```SQL
test_db=# UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Книга') WHERE фамилия = 'Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Монитор') WHERE фамилия = 'Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET заказ = (SELECT id FROM orders WHERE наименование = 'Гитара') WHERE фамилия = 'Иоганн Себастьян Бах';
UPDATE 1
test_db=# 
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```SQL
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |             фамилия             | страна проживания | заказ 
----+----------------------------------------+-----------------------------------+------------
  1 | Иванов Иван Иванович | USA                               |          3
  2 | Петров Петр Петрович | Canada                            |          4
  3 | Иоганн Себастьян Бах | Japan                             |          5
(3 rows)

test_db=# 
```

Задача 5.

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```SQL
test_db=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)

test_db=# 
```

```text
explain выдает план выполнения запроса, что было проверено, сколько "ресурсов" было потрачено и т.д.:
  - cost=0.00 - потрачено на получения первого значения.
  - cost=18.10 - потрачено на получения всех строк.
  - rows=806 - количество проверенных строк.
  - width=72 - размер каждой строки в байтах составил.
  - Filter: ("заказ" IS NOT NULL) - какой фильтр использовался в запросе.
```

Задача 6.

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```bash
root@c7f335dd965a:/# export PGPASSWORD=postgres && pg_dumpall -h localhost -U postgres > /media/postgresql/backup/test_db.sql
root@c7f335dd965a:/# ls /media/postgresql/backup/
test_db.sql
root@c7f335dd965a:/# exit
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```bash
sergo@sergo-vb:~/6.2$ docker stop psql
psql
sergo@sergo-vb:~/6.2$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED        STATUS                      PORTS     NAMES
c7f335dd965a   postgres:12   "docker-entrypoint.s…"   20 hours ago   Exited (0) 18 seconds ago             psql
627cc0d642ff   centos        "/bin/bash"              2 weeks ago    Exited (0) 2 weeks ago                amazing_williams
a33da711f4f6   debian        "bash"                   2 weeks ago    Exited (137) 2 weeks ago              brave_gagarin
45b1e276764e   new-d/nginx   "/docker-entrypoint.…"   3 weeks ago    Exited (0) 3 weeks ago                nginx
03d542c1cc69   nginx         "/docker-entrypoint.…"   3 weeks ago    Exited (0) 3 weeks ago                naughty_swartz
77fffbe17508   nginx         "/docker-entrypoint.…"   3 weeks ago    Exited (127) 3 weeks ago              exciting_turing
5dd0fa2fe615   nginx         "/docker-entrypoint.…"   3 weeks ago    Exited (0) 3 weeks ago                beautiful_blackburn
5478e39bbbb4   nginx         "/docker-entrypoint.…"   3 weeks ago    Exited (0) 3 weeks ago                sharp_cartwright
ed84e41e896a   nginx         "/docker-entrypoint.…"   3 weeks ago    Exited (0) 3 weeks ago                objective_antonelli
5a5d0a342e74   nginx         "/docker-entrypoint.…"   3 weeks ago    Exited (0) 3 weeks ago                serene_cannon
b613fd858b72   ubuntu        "bash"                   3 weeks ago    Exited (0) 3 weeks ago                bold_hugle
48558a78dd29   hello-world   "/hello"                 3 weeks ago    Exited (0) 3 weeks ago                funny_varahamihira
sergo@sergo-vb:
```

Поднимите новый пустой контейнер с PostgreSQL.

```bash
sergo@sergo-vb:~/6.2$ docker run --rm -d -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=test_db -v psql_backup:/media/postgresql/backup --name new_psql postgres:12
25efa15099f6c29e5ba555be187890ea2c8732a0c73850c1197b5632d9ef512a
sergo@sergo-vb:~/6.2$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                      PORTS      NAMES
25efa15099f6   postgres:12   "docker-entrypoint.s…"   6 seconds ago   Up 5 seconds                5432/tcp   new_psql
c7f335dd965a   postgres:12   "docker-entrypoint.s…"   20 hours ago    Exited (0) 13 minutes ago              psql
627cc0d642ff   centos        "/bin/bash"              2 weeks ago     Exited (0) 2 weeks ago                 amazing_williams
a33da711f4f6   debian        "bash"                   2 weeks ago     Exited (137) 2 weeks ago               brave_gagarin
45b1e276764e   new-d/nginx   "/docker-entrypoint.…"   3 weeks ago     Exited (0) 3 weeks ago                 nginx
03d542c1cc69   nginx         "/docker-entrypoint.…"   3 weeks ago     Exited (0) 3 weeks ago                 naughty_swartz
77fffbe17508   nginx         "/docker-entrypoint.…"   3 weeks ago     Exited (127) 3 weeks ago               exciting_turing
5dd0fa2fe615   nginx         "/docker-entrypoint.…"   3 weeks ago     Exited (0) 3 weeks ago                 beautiful_blackburn
5478e39bbbb4   nginx         "/docker-entrypoint.…"   3 weeks ago     Exited (0) 3 weeks ago                 sharp_cartwright
ed84e41e896a   nginx         "/docker-entrypoint.…"   3 weeks ago     Exited (0) 3 weeks ago                 objective_antonelli
5a5d0a342e74   nginx         "/docker-entrypoint.…"   3 weeks ago     Exited (0) 3 weeks ago                 serene_cannon
b613fd858b72   ubuntu        "bash"                   3 weeks ago     Exited (0) 3 weeks ago                 bold_hugle
48558a78dd29   hello-world   "/hello"                 3 weeks ago     Exited (0) 3 weeks ago                 funny_varahamihira
sergo@sergo-vb:~/6.2$ 

```

Восстановите БД test_db в новом контейнере.

```bash
sergo@sergo-vb:/$ sudo docker exec -it new_psql /bin/bash
root@25efa15099f6:/# ls /media/postgresql/backup/
test_db.sql
root@25efa15099f6:/# export PGPASSWORD=postgres && psql -h localhost -U postgres -f /media/postgresql/backup/test_db.sql test_db
SET
SET
SET
psql:/media/postgresql/backup/test_db.sql:14: ERROR:  role "postgres" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "postgres".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
You are now connected to database "postgres" as user "postgres".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
psql:/media/postgresql/backup/test_db.sql:112: ERROR:  database "test_db" already exists
ALTER DATABASE
You are now connected to database "test_db" as user "postgres".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval 
--------
      5
(1 row)

 setval 
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
root@25efa15099f6:/# psql -U postgres
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

```

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```SQL
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

postgres=# 
```

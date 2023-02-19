# Домашнее задание к занятию "6.4 PostgreSQL""  

Задача 1.

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```yaml
version: '3.9'

volumes:
  data: {}
  backup: {}

services:

  postgres:
    image: postgres:13
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

```bash
sergo@sergo-vb:~/6$ sudo docker-compose start
[+] Running 1/1
 ? Container psql  Started                                                                                                                                                                                             0.3s
sergo@sergo-vb:~/6$ sudo docker-compose ps
NAME                IMAGE               COMMAND                  SERVICE             CREATED             STATUS              PORTS
psql                postgres:13         "docker-entrypoint.s…"   postgres            27 seconds ago      Up 2 seconds        0.0.0.0:5432->5432/tcp
sergo@sergo-vb:~/6$ 

```

Подключитесь к БД PostgreSQL используя `psql`.

```bash
sergo@sergo-vb:~/6$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES
3ea7426246f2   postgres:13   "docker-entrypoint.s…"   13 minutes ago   Up 13 minutes   0.0.0.0:5432->5432/tcp   psql
sergo@sergo-vb:~/6$ docker exec -it -u postgres psql /bin/bash
postgres@3ea7426246f2:/$ psql
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.

postgres=# 
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД
```sql
\l[+]   [PATTERN]      list databases
```
- подключения к БД
```sql
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
```
- вывода списка таблиц
```sql
\dt[S+] [PATTERN]      list tables
```
- вывода описания содержимого таблиц
```sql
\d[S+]                 list tables, views, and sequences
```
- выхода из psql
```sql
\q
```
Задача 2.  

Используя psql создайте БД test_database.

```sql
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# 
```
Изучите бэкап БД.

<details><summary></summary>

```sql
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0 (Debian 13.0-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, title, price) FROM stdin;
1	War and peace	100
2	My little database	500
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
6	WAL never lies	900
7	Me and my bash-pet	499
8	Dbiezdmin	501
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 8, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--
```
Восстановите бэкап БД в test_database.

```sql
postgres@3ea7426246f2:/home/postgres$ psql test_database < /home/postgres/test_dump.sql
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
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
postgres@3ea7426246f2:/home/postgres$ 
```
</details>

Перейдите в управляющую консоль psql внутри контейнера.

```sql
postgres@3ea7426246f2:/home/postgres$ psql
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.

postgres=#
```
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```sql
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE;
ANALYZE
test_database=#
```
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

```sql
test_database=# SELECT MAX(avg_width) FROM pg_stats WHERE tablename = 'orders';
 max 
-----
  16
(1 row)
```
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.

Задача 3.

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```sql
test_database=# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
INSERT 0 3
test_database=# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499;
INSERT 0 5
test_database=# \d
```

```sql
test_database=# TABLE orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# TABLE orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# 
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Да, можно. PostgreSQL позволяет декларировать, что некоторая таблица разделяется на секции. Секционированием данных называется разбиение одной большой логической таблицы на несколько меньших физических секций.

Задача 4

Используя утилиту pg_dump создайте бекап БД test_database.

```sql
root@3ea7426246f2:/home/postgres# ls
test_dump.sql
root@3ea7426246f2:/home/postgres# pg_dump -U postgres -d test_database > /home/postgres/test_database_dump.sql
root@3ea7426246f2:/home/postgres# ls
test_database_dump.sql	test_dump.sql
root@3ea7426246f2:/home/postgres# 
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

При создании таблицы добавить критерий UNIQUE напротив объявления полей таблицы:
```sql
title character varying(80) NOT NULL UNIQUE
```
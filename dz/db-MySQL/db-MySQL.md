# Домашнее задание к занятию "6.3 Домашнее задание к занятию "MySQL"  

Задача 1.

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```yaml
version: '3.9'

volumes:
  data: {}
  backup: {}

services:

  mysql:
    image: mysql:8
    container_name: mysql8
    ports:
      - "0.0.0.0:3306:3306"
    volumes:
      - data:/var/lib/mysql
      - backup:/media/mysql/backup
    environment:
      MYSQL_ROOT_PASSWORD: "mysql"
      MYSQL_DATABASE: "test_db"
    restart: always
```

```bash
sergo@sergo-vb:~/6$ docker compose start
[+] Running 1/1
 ⠿ Container mysql8  Started                                                                                                                                                                                                            0.3s
sergo@sergo-vb:~/6$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                     PORTS                               NAMES
c7e91ea495a2   mysql:8       "docker-entrypoint.s…"   6 minutes ago   Up 4 seconds               0.0.0.0:3306->3306/tcp, 33060/tcp   mysql8
```

Изучите бэкап БД и восстановитесь из него.

```bash
sergo@sergo-vb:~/6$ ls
docker-compose.yaml  test_dump.sql
sergo@sergo-vb:~/6$ cat test_dump.sql 
-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: localhost    Database: test_db
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'War and Peace',100),(2,'My little pony',500),(3,'Adventure mysql times',300),(4,'Server gravity falls',300),(5,'Log gossips',123);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-11 18:15:33
sergo@sergo-vb:~/6$ 
```

```sql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

mysql> exit
Bye
bash-4.4# mysql -u root -p test_db < /media/mysql/backup/test_dump.sql
Enter password: 
bash-4.4# 
```

Перейдите в управляющую консоль mysql внутри контейнера.

Используя команду \h получите список управляющих команд.

```SQL
bash-4.4# mysql -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

mysql> 
```

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

```sql
mysql> \s
--------------
mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		11
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.32 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			35 min 41 sec

Threads: 2  Questions: 53  Slow queries: 0  Opens: 156  Flush tables: 3  Open tables: 74  Queries per second avg: 0.024
--------------

mysql> 
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```sql
mysql> use test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

mysql> 
```

Приведите в ответе количество записей с price > 300.

```sql
mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

mysql> 
```

Задача 2.

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
  - Фамилия "Pretty"
  - Имя "James"

```sql
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
Query OK, 0 rows affected (0.01 sec)

mysql> 
```

Предоставьте привелегии пользователю test на операции SELECT базы test_db.

```sql
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.

```sql
mysql> select * from information_schema.user_attributes where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

mysql> 
```

Задача 3.

Установите профилирование `SET profiling = 1`.

```sql
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> 
```

Изучите вывод профилирования команд `SHOW PROFILES;`.

```sql
mysql> show profiles;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00014975 | SET profiling = 1 |
|        2 | 0.00021675 | SELECT DATABASE() |
|        3 | 0.00068750 | show databases    |
|        4 | 0.00057025 | show tables       |
|        5 | 0.00023975 | SET profiling = 1 |
+----------+------------+-------------------+
5 rows in set, 1 warning (0.00 sec)

mysql> 
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```sql
mysql> select table_name, engine from information_schema.tables where table_schema = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> 
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:

- на `MyISAM`
- на `InnoDB`

```sql
mysql> alter table orders engine = myisam;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        1 | 0.00014975 | SET profiling = 1                                                                       |
|        2 | 0.00021675 | SELECT DATABASE()                                                                       |
|        3 | 0.00068750 | show databases                                                                          |
|        4 | 0.00057025 | show tables                                                                             |
|        5 | 0.00023975 | SET profiling = 1                                                                       |
|        6 | 0.00438400 | SHOW TABLE STATUS                                                                       |
|        7 | 0.00087175 | select table_name, engine from information_schema.tables where table_schema = 'test_db' |
|        8 | 0.02129400 | alter table orders engine = myisam                                                      |
+----------+------------+-----------------------------------------------------------------------------------------+
8 rows in set, 1 warning (0.00 sec)

mysql> alter table orders engine = innodb;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        1 | 0.00014975 | SET profiling = 1                                                                       |
|        2 | 0.00021675 | SELECT DATABASE()                                                                       |
|        3 | 0.00068750 | show databases                                                                          |
|        4 | 0.00057025 | show tables                                                                             |
|        5 | 0.00023975 | SET profiling = 1                                                                       |
|        6 | 0.00438400 | SHOW TABLE STATUS                                                                       |
|        7 | 0.00087175 | select table_name, engine from information_schema.tables where table_schema = 'test_db' |
|        8 | 0.02129400 | alter table orders engine = myisam                                                      |
|        9 | 0.02014375 | alter table orders engine = innodb                                                      |
+----------+------------+-----------------------------------------------------------------------------------------+
9 rows in set, 1 warning (0.00 sec)

mysql> 
```

Задача 4.

Изучите файл `my.cnf` в директории /etc/mysql. (находился в другом месте)

```bash
bash-4.4# cd etc/
bash-4.4# ls
GREP_COLORS	   bindresvport.blacklist  dnf		gnupg	  host.conf  issue.net	   libaudit.conf  my.cnf
```

```conf
bash-4.4# cat my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
bash-4.4# 
```

Если я правильно понимаю, то можно было бы создать my.cnf в /etc/mysql/conf.d/ и mysql от туда бы подхватил доп настройки, но в рамках домашнего задания просто дабавил нужные строки в этот же файл.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```bash
sergo@sergo-vb:~/6$ docker ps -q | xargs  docker stats --no-stream
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O       BLOCK I/O      PIDS
c7e91ea495a2   mysql8    0.15%     369.5MiB / 1.929GiB   18.71%    1.44kB / 0B   7MB / 32.9MB   39
```

- innodb_flush_method = O_DSYNC
- innodb_flush_log_at_trx_commit = 2
- innodb_file_per_table = ON
- innodb_log_buffer_size = 1M
- innodb_buffer_pool_size = 600M
- max_binlog_size = 100M

```conf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

# Добавил в рамках дз:
innodb_flush_method = O_DSYNC
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 600M
max_binlog_size = 100M
```

Домашнее задание к занятию "3.3 Операционные системы (лекция 1)"  

1. Какой системный вызов делает команда cd?  (image - 1.png)

В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте.  

Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.    

chdir("/tmp")  

2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Сделано: (image - 2-1.png)   

vagrant@netology1:~$ file /dev/tty  
/dev/tty: character special (5/0)  
vagrant@netology1:~$ file /dev/sda  
/dev/sda: block special (8/0)  
vagrant@netology1:~$ file /bin/bash  
/bin/bash: ELF 64-bit LSB shared object, x86-64  

Используя strace выясните, где находится база данных file на основании которой она делает свои догадки. (image - 2-2.png)  

vagrant@vagrant:~$ strace file
...  
newfstatat(AT_FDCWD, "/home/vagrant/.magic.mgc", 0x7ffd3c876410, 0) = -1 ENOENT (No such file or directory)  
newfstatat(AT_FDCWD, "/home/vagrant/.magic", 0x7ffd3c876410, 0) = -1 ENOENT (No such file or directory)  
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)  
newfstatat(AT_FDCWD, "/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}, 0) = 0  
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3  
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=111, ...}, AT_EMPTY_PATH) = 0  
read(3, "# Magic local data for file(1) c"..., 4096) = 111  
read(3, "", 4096)                       = 0  
close(3)                                = 0  
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3  
...  

/etc/magic  
/usr/share/misc/magic.mgc  

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе). 

(image - 3.png)  

root@vagrant:/home/vagrant# cd test5  
root@vagrant:/home/vagrant/test5# ls  
root@vagrant:/home/vagrant/test5# ping localhost > ping1.txt  
^Z  
[1]+  Stopped                 ping localhost > ping1.txt  
root@vagrant:/home/vagrant/test5# bg  
[1]+ ping localhost > ping1.txt &  
root@vagrant:/home/vagrant/test5# jobs -l  
[1]+  1183 Running                 ping localhost > ping1.txt &  
root@vagrant:/home/vagrant/test5# ls  
ping1.txt  
root@vagrant:/home/vagrant/test5# rm ping1.txt  
root@vagrant:/home/vagrant/test5# lsof | grep deleted  
ping      1183                           root    1w      REG              253,0     3890     659496 /home/vagrant/test5/ping1.txt (deleted)  
root@vagrant:/home/vagrant/test5# echo "" > /proc/1183/fd/1  

С этим заданием пришлось повозиться, в "Вопросах по хаданию" был вопрос студента по решению и совет эксперта по поводу echo “” > /proc/$PID/fd/$descripter..

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?  

Зомби не потребляют никаких ресурсов, память и файловые дескрипторы таких процессов уже освобождены. Остается только запись в таблице процессов, которая занимает несколько десятков байт памяти. Tдиничный зомби процесс на систему никак не влияет. НО он явный индикатор того, что у какого то процесса в системе что то пошло не так.  
Запись в таблице процессов небольшая, но вы не можете использовать идентификатор процесса, пока зомби-процесс не будет освобожден.  
На 64-разрядной ОС это не создаст проблемы, потому что PCB больше, чем запись таблицы процессов.  
Огромное количество зомби-процессов может повлиять на свободную память, доступную для других процессов.  
В этом случае оставшиеся идентификаторы процессов монополизируются зомби.  
Если не остается ни одного идентификатора процесса, другие процессы не могут быть запущены.  

5. В iovisor BCC есть утилита opensnoop:  (image - 5.png)  

Установил: apt-get install bpfcc-tools linux-headers-$(uname -r)

На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты?  
Если я правильно понял задание, то решение ниже:  

root@vagrant:/# /usr/sbin/opensnoop-bpfcc  
...  
PID    COMM               FD ERR PATH  
1183   ping                5   0 /etc/hosts  
1183   ping                5   0 /etc/hosts  
1090   vminfo              6   0 /var/run/utmp  
640    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services  
640    dbus-daemon        19   0 /usr/share/dbus-1/system-services  
640    dbus-daemon        -1   2 /lib/dbus-1/system-services  
640    dbus-daemon        19   0 /var/lib/snapd/dbus-1/system-services/  
1183   ping                5   0 /etc/hosts  
1183   ping                5   0 /etc/hosts  
1183   ping                5   0 /etc/hosts  
...  

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.  (image - 6.png)  

vagrant@vagrant:~$ man uname  - в этом мануале такой информации не обнаружено, но в See Also было предложено посмотреть uname(2)  

vagrant@vagrant:~$ man uname.2  - квест по поиску мануала  
No manual entry for uname.2  

vagrant@vagrant:~$ sudo apt-get install man-db manpages manpages-posix manpages-posix-dev  

vagrant@vagrant:~$ man uname.2  

цитата: Part of the utsname information is also accessible via /proc/sys/kernel/{ostype,  hostname,  osrelease,  version, domainname}.  

7. Чем отличается последовательность команд через ; и через && в bash? Например:  

root@netology1:~# test -d /tmp/some_dir; echo Hi  
Hi  
root@netology1:~# test -d /tmp/some_dir && echo Hi  
root@netology1:~#  

В командной строке можно указать несколько команд, разделенных символом ';', напримаер: command1; command2; command3  
Система Linux выполняет команды в том порядке, в котором они стоят в командной строке, и печатает вывод этих команд в том же порядке. Этот процесс называется последовательным выполнением.

&& - оператора AND: условный оператор для последовательного выполнения команд.  
Оператор выполнит вторую команду только в том случае, если команда 1 успешно выполнена.  

Существуют также другие операторы для bash:  
OR Оператор (||) - OR  полностью противоположна оператору &&. OR выполнит вторую команду только в том случае, если первая команда провалится.  
Оператор AND & OR (&& и ||) - Комбинация этих двух операторов, как например, if … else в программировании.  
Оператор PIPE (|) - это своего рода оператор, который может использоваться для отображения вывода первой команды, принимая ввод второй команды.  
Амперсанд Оператор (&) - Оператор Амперсанда – это своего рода оператор, который выполняет заданные команды в фоновом режиме.Можно использовать этот оператор для одновременного выполнения нескольких команд.

Есть ли смысл использовать в bash &&, если применить set -e?

параметр -e указывает оболочке выйти, если команда дает ненулевой статус выхода. Проще говоря, оболочка завершает работу при сбое команды.

Я думаю, что использование && совместно с set -e бессмысленно. Оператор && и так подразумевает прерывание выполнения команд, если была ошибка. Возможно не прав, прошу вас прокомментировать данный момент.  

8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?  

set -e - скрипт немедленно завершит работу, если любая команда выйдет с ошибкой. По-умолчанию, игнорируются любые неудачи и сценарий продолжет выполнятся. Если предполагается, что команда может завершиться с ошибкой, но это не критично, можно использовать пайплайн || true.  
set -u - Благодаря ему оболочка проверяет инициализацию переменных в скрипте. Если переменной не будет, скрипт немедленно завершиться. Данный параметр достаточно умен, чтобы нормально работать с переменной по-умолчанию ${MY_VAR:-$DEFAULT} и условными операторами (if, while, и др).  
set -x - С помощью него bash печатает в стандартный вывод все команды перед их исполнением. Стоит учитывать, что все переменные будут уже доставлены, и с этим нужно быть аккуратнее, к примеру если используете пароли. Полезен при отладке.  
set -o pipefail - Bash возвращает только код ошибки последней команды в пайпе (конвейере). И параметр -e проверяет только его. Если нужно убедиться, что все команды в пайпах завершились успешно, нужно использовать -o pipefail.  

9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе.  (image - 9-1.png)  

vagrant@vagrant:~$ ps -o stat  
STAT  
Ss  
R+  
vagrant@vagrant:~$   

В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными). (image - 9-2.png)  

D    непрерывный режим сна (процесс ожидает ввода-вывода)  
R    процесс выполняется в данный момент;  
S    прерываемый режим сна (ожидание завершения события)  
T    процесс остановлен сигналом управления заданием  
t    остановлено отладчиком  
W    процесс в свопе (не используется с версии 2.6.xx kernel)  
X    мертв (should never be seen)  
Z    zombie или defunct процесс, завершенный, но не возвращенный его родителем  

<    процесс с высоким приоритетом (не хорошо для остальных пользователей)  
N    процесс с низким приоритетом (хорошо для остальных пользователей)  
L    имеет страницы, заблокированные в памяти (для ввода-вывода в реальном времени и пользовательского ввода-вывода)  
s    лидер сессии  
l    является многопоточным (с использованием CLONE_THREAD, как это делают NPTL pthreads)  
+    находится в группе процессов переднего плана  

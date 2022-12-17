Домашнее задание к занятию "4.2 Использование Python для решения типовых DevOps задач"  

1. Задание 1  
Есть скрипт:  

#!/usr/bin/env python3  
a = 1  
b = '2'  
c = a + b  

Вопросы:  

Какое значение будет присвоено переменной c?  
Если выполнить данный скрипт без изменений, то мы получим ошибку: TypeError: unsupported operand type(s) for +: 'int' and 'str'  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/1-1.png"
  alt="image 1-1.png"
  title="image 1-1.png"
  style="display: inline-block; margin: 0 auto; width: 200px">

Как получить для переменной c значение 12?	Сменить тип переменной a на str, тогда puthon склеит две переменные.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/1-2.png"
  alt="image 1-2.png"
  title="image 1-2.png"
  style="display: inline-block; margin: 0 auto; width: 200px">

Как получить для переменной c значение 3?	Сменить тип переменной b на int, тогда получим арифметическую операцию сложение.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/1-3.png"
  alt="image 1-3.png"
  title="image 1-3.png"
  style="display: inline-block; margin: 0 auto; width: 200px">

2. Задание 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся.  

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?  

#!/usr/bin/env python3  

import os  

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]  
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False  
for result in result_os.split('\n'):  
    if result.find('modified') != -1:  
        prepare_result = result.replace('\tmodified:   ', '')  
        print(prepare_result)  
        break  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/2-1.png"
  alt="image 2-1.png"
  title="image 2-1.png"
  style="display: inline-block; margin: 0 auto; width: 200px">

Ваш скрипт:  

#!/usr/bin/env python3  

import os  

bash_command = ["cd C:\\Users\\sergo\\YandexDisk\\Study\\Netology\\devops-netology", "git status"]  
result_os = os.popen(' && '.join(bash_command)).read()  
for result in result_os.split('\n'):  
    if result.find('modified') != -1:  
        prepare_result = result.replace('\tmodified:   ', '')  
        print(prepare_result)  
        break  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/2-2.png"
  alt="image 2-2.png"
  title="image 2-2.png"
  style="display: inline-block; margin: 0 auto; width: 200px">

3. Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.  

Ваш скрипт:  

#!/usr/bin/env python3  

import os  
print("Введите путь")  
somedir = input()  
bash_command = ["cd " + somedir, "git status"]  
result_os = os.popen(' && '.join(bash_command)).read()  
for result in result_os.split('\n'):  
    if result.find('modified') != -1:  
        prepare_result = result.replace('\tmodified:   ', '')  
        print("Файлы modified:")  
        print(prepare_result)  
        break  

Вывод скрипта при запуске при тестировании:  

PS C:\Users\sergo\YandexDisk\Study\Netology\DevOps\4. Скриптовые языки и языки разметки Python, Bash, YAML, JSON\4.2 Использование Python для решения типовых DevOps задач\dz_python> & "C:/Program Files/Python310/python.exe" c:/Python/2.py  
Введите путь  
C:\Users\sergo\YandexDisk\Study\  
fatal: not a git repository (or any of the parent directories): .git  
PS C:\Users\sergo\YandexDisk\Study\Netology\DevOps\4. Скриптовые языки и языки разметки Python, Bash, YAML, JSON\4.2 Использование Python для решения типовых DevOps задач\dz_python> & "C:/Program Files/Python310/python.exe" c:/Python/2.py  
Введите путь  
C:\Users\sergo\YandexDisk\Study\Netology\devops-netology\  
Файлы modified:  
dz/new.txt  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; width: 200px">

4. Задание 4
Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис.  

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков.  

Мы хотим написать скрипт, который:  

опрашивает веб-сервисы,  
получает их IP,  
выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.  
Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.  

Ваш скрипт:  

#!/usr/bin/env python3  

import socket  
import time   

sites = {'market.yandex.ru': '','music.yandex.ru': ''}  

for site in sites:  
    ip = socket.gethostbyname(site)  
    sites[site] = ip  

while True:  
    for site in sites:  
        ip = sites[site]  
        new_ip = socket.gethostbyname(site)  
        if new_ip != ip:  
            sites[site] = new_ip  
            print(f'[ERROR] {site} IP mismatch: {ip} {new_ip}')  

        print(f'{site} IP: {new_ip}')  

    time.sleep(0.1)  

Вывод скрипта при запуске при тестировании:  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_python/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; width: 200px">
Домашнее задание к занятию "4.1 Командная оболочка Bash: практические навыки"  

1. Задание 1  
Есть скрипт:  

a=1  
b=2  
c=a+b  
d=$a+$b  
e=$(($a+$b))  
Какие значения переменным c,d,e будут присвоены? Почему?  


c значение a+b - bash изначально считает все данные типом str, поэтому в переменную записались 3 символа, символ 'a', символ '+' и символ 'b'  
d значение 1+2 - $a и $b считываются bash как переменные, поэтому он и берет из них данные, но далее тип данных остается str, поэтому арифметической операции не произошло  
e значение 3 - двойные скобки перобразуют тип данных в int, поэтому при считывании данных из переменных мы получили их сумму  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_bash/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 300px">

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:  

while ((1==1)  
do  
	curl https://localhost:4757  
	if (($? != 0))  
	then  
		date >> curl.log  
	fi  
done  

Исправленная версия:  

vagrant@vagrant:~$ cat -v z2.ssh  
#!/usr/bin/env bash  
while ((1==1))  
do  
  curl https://localhost:4757  
  if (($? != 0))  
  then  
    date > curl.log  
  else  
    break  
  fi  
done  
vagrant@vagrant:~$   

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_bash/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 300px">

Добавил break при успешной операции, также заменил >> на >, файл будет не добавлять новую строку, а перезаписываться.  

3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.  

Ваш скрипт:  

vagrant@vagrant:~$ cat ./z3.ssh  
#!/usr/bin/env bash  
array_int=(192.168.0.1 173.194.222.113 87.250.250.242)  
for i in {1..5}  
do  
  for i in ${array_int[@]}  
  do  
    nc -vz $i 80  
    if (($? != 0))  
    then  
      date > curl.log  
    fi  
  done  
done  

Сделал через вложенный цикл, скрипт работает  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_bash/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 300px">
  
4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.  

vagrant@vagrant:~$ cat ./z4.ssh  
#!/usr/bin/env bash  
array_int=(192.168.0.1 173.194.222.113 87.250.250.242)  
while ((1==1))  
do  
  for i in ${array_int[@]}  
  do  
    nc -vz $i 80  
    if (($? != 0))  
    then  
      echo $i > error  
      break  
    fi  
  done  
done  
vagrant@vagrant:~$  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_bash/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 300px">
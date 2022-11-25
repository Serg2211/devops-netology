Домашнее задание к занятию "3.6 Компьютерные сети (лекция 1)"  

1. Работа c HTTP через телнет.  (image 1.png)  

vagrant@vagrant:~$ telnet stackoverflow.com 80  
Trying 151.101.129.69...  
Connected to stackoverflow.com.  
Escape character is '^]'.  
GET /questions HTTP/1.0  
HOST: stackoverflow.com  

HTTP/1.1 403 Forbidden  
Connection: close  
Content-Length: 1923  
Server: Varnish  
Retry-After: 0  
Content-Type: text/html  
Accept-Ranges: bytes  
Date: Fri, 25 Nov 2022 16:00:29 GMT  
Via: 1.1 varnish  
X-Served-By: cache-fra-eddf8230054-FRA  
X-Cache: MISS  
X-Cache-Hits: 0  
X-Timer: S1669392030.761562,VS0,VE1  
X-DNS-Prefetch-Control: off  

HTTP/1.1 403 Forbidden - 403 Доступ к ресурсу запрещен  

2. Повторите задание 1 в браузере, используя консоль разработчика F12  

укажите в ответе полученный HTTP код.  
URL запроса: https://stackoverflow.com/  
Метод запроса: GET  
Код статуса: 200   
Удаленный адрес: 151.101.129.69:443  

проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?  

Не смог загрузиться analytics.js  
Далее загрузилась сама страница сайта с кодом 200  (image 2.png)  

3. Какой IP адрес у вас в интернете? (image 3.png)  

Мой IP: 178.47.177.131   

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois  

vagrant@vagrant:~$ whois -h whois.ripe.net 178.47.177.131  (image 4.png)  
...  
% Information related to '178.47.160.0/19AS12389'  

route:          178.47.160.0/19  
descr:          Rostelecom networks  
origin:         AS12389  
mnt-by:         ROSTELECOM-MNT  
created:        2018-10-31T11:47:00Z  
last-modified:  2018-10-31T11:47:00Z  
source:         RIPE # Filtered  

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute  (image 5.png)  

vagrant@vagrant:~$ traceroute 8.8.8.8  
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets  
 1  _gateway (10.0.2.2)  0.247 ms  0.332 ms  0.312 ms  
 2  * * *  
 3  * * *  
 4  * * *  
 5  * * *  
 6  * * *  
 7  * * *  
 8  * * *  
 9  * * *  
10  * * *  
11  * * *  
12  * * *  
13  * * *  
14  * * *  
15  * * *  
16  * * *  
17  * * *  
18  * * *  
19  * * *  
20  * * *  
21  * * *  
22  * * *  
23  * * *  
24  * * *  
25  * * *  
26  * * *  
27  * * *  
28  * * *  
29  * * *  
30  * * *  
vagrant@vagrant:~$  

Звездочки, отображаемые при трассировке, могут означать то, что настройки маршрутизатора выбраны таким образом, чтобы игнорировать ответы для трассировки. Отключение ответа для трассировки может быть сделано из соображений безопасности, а также для того, чтобы снизить нагрузку на канал при отдельных разновидностях DDoS-атак.  

6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?  (image 6.png)

№10. AS15169  108.170.232.251      0.0%    10   54.6  56.1  54.4  67.8   4.1   

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? Воспользуйтесь утилитой dig  

(image 7.png)  

vagrant@vagrant:~$ dig google.com NS  
...   
google.com.		54967	IN	NS	ns1.google.com.  
google.com.		54967	IN	NS	ns2.google.com.  
google.com.		54967	IN	NS	ns4.google.com.  
google.com.		54967	IN	NS	ns3.google.com.  

vagrant@vagrant:~$ dig google.com A  
...  
google.com.		132	IN	A	64.233.162.113  
google.com.		132	IN	A	64.233.162.139  
google.com.		132	IN	A	64.233.162.101  
google.com.		132	IN	A	64.233.162.102  
google.com.		132	IN	A	64.233.162.138  
google.com.		132	IN	A	64.233.162.100  

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой dig  (image 8.png)  

vagrant@vagrant:~$ dig google.com A +noall +answer  
google.com.		206	IN	A	64.233.162.138  
google.com.		206	IN	A	64.233.162.113  
google.com.		206	IN	A	64.233.162.100  
google.com.		206	IN	A	64.233.162.139  
google.com.		206	IN	A	64.233.162.101  
google.com.		206	IN	A	64.233.162.102  
vagrant@vagrant:~$ dig -x 64.233.162.139 +noall +answer  
139.162.233.64.in-addr.arpa. 6518 IN	PTR	li-in-f139.1e100.net.  
vagrant@vagrant:~$ dig -x 64.233.162.113 +noall +answer  
113.162.233.64.in-addr.arpa. 6434 IN	PTR	li-in-f113.1e100.net.  
vagrant@vagrant:~$ dig -x 64.233.162.100 +noall +answer  
100.162.233.64.in-addr.arpa. 52380 IN	PTR	li-in-f100.1e100.net.  
vagrant@vagrant:~$ dig -x 64.233.162.139 +noall +answer  
139.162.233.64.in-addr.arpa. 6492 IN	PTR	li-in-f139.1e100.net.  
vagrant@vagrant:~$ dig -x 64.233.162.101 +noall +answer  
101.162.233.64.in-addr.arpa. 50184 IN	PTR	li-in-f101.1e100.net.  
vagrant@vagrant:~$ dig -x 64.233.162.102 +noall +answer  
102.162.233.64.in-addr.arpa. 51791 IN	PTR	li-in-f102.1e100.net.  
vagrant@vagrant:~$   

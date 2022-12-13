Домашнее задание к занятию "3.9 Элементы безопасности информационных систем"  

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px"> 

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  

vagrant@vagrant:~$ sudo apt install apache2   

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/3-1.png"
  alt="image 3-1.png"
  title="image 3-1.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">
  
vagrant@vagrant:~$ sudo a2enmod ssl  
Considering dependency setenvif for ssl:  
Module setenvif already enabled  
Considering dependency mime for ssl:  
Module mime already enabled  
Considering dependency socache_shmcb for ssl:  
Enabling module socache_shmcb.  
Enabling module ssl.  
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.  
To activate the new configuration, you need to run:  
  systemctl restart apache2  
vagrant@vagrant:~$ sudo systemctl restart apache2  

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt  

vagrant@vagrant:~$ sudo nano /etc/apache2/sites-available/10.0.2.15.conf  

<VirtualHost *:443>  
   ServerName 10.0.2.15  
   DocumentRoot /var/www/10.0.2.15  
   SSLEngine on  
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt  
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key  
</VirtualHost>  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/3-2.png"
  alt="image 3-2.png"
  title="image 3-2.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">

vagrant@vagrant:~$ sudo mkdir /var/www/10.0.2.15  
vagrant@vagrant:~$ sudo nano /var/www/10.0.2.15/index.html  
vagrant@vagrant:~$ sudo a2ensite 10.0.2.15.conf  
Enabling site 10.0.2.15.  
To activate the new configuration, you need to run:  
  systemctl reload apache2  
vagrant@vagrant:~$ sudo apache2ctl configtest  
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message  
Syntax OK  
vagrant@vagrant:~$ sudo systemctl reload apache2  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/3-3.png"
  alt="image 3-3.png"
  title="image 3-3.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px"> 

vagrant@vagrant:~$ curl --insecure -v https://10.0.2.15  
*   Trying 10.0.2.15:443...  
* Connected to 10.0.2.15 (10.0.2.15) port 443 (#0)  
* ALPN, offering h2  
* ALPN, offering http/1.1  
* TLSv1.0 (OUT), TLS header, Certificate Status (22):  
* TLSv1.3 (OUT), TLS handshake, Client hello (1):  
* TLSv1.2 (IN), TLS header, Certificate Status (22):  
* TLSv1.3 (IN), TLS handshake, Server hello (2):  
* TLSv1.2 (IN), TLS header, Finished (20):  
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):  
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* TLSv1.3 (IN), TLS handshake, Certificate (11):  
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* TLSv1.3 (IN), TLS handshake, CERT verify (15):  
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* TLSv1.3 (IN), TLS handshake, Finished (20):  
* TLSv1.2 (OUT), TLS header, Finished (20):  
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):  
* TLSv1.2 (OUT), TLS header, Supplemental data (23):  
* TLSv1.3 (OUT), TLS handshake, Finished (20):  
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384  
* ALPN, server accepted to use http/1.1  
* Server certificate:  
*  subject: C=RU; ST=Tyum-obl; L=Tyumen; O=NewCompany  
*  start date: Dec  8 14:21:59 2022 GMT  
*  expire date: Dec  8 14:21:59 2023 GMT  
*  issuer: C=RU; ST=Tyum-obl; L=Tyumen; O=NewCompany  
*  SSL certificate verify result: self-signed certificate (18), continuing anyway.  
* TLSv1.2 (OUT), TLS header, Supplemental data (23):  
> GET / HTTP/1.1  
> Host: 10.0.2.15  
> User-Agent: curl/7.81.0  
> Accept: */*  
> 
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):  
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):  
* old SSL session ID is stale, removing  
* TLSv1.2 (IN), TLS header, Supplemental data (23):  
* Mark bundle as not supporting multiuse  
< HTTP/1.1 200 OK  
< Date: Thu, 08 Dec 2022 14:42:36 GMT  
< Server: Apache/2.4.52 (Ubuntu)  
< Last-Modified: Thu, 08 Dec 2022 14:40:02 GMT  
< ETag: "14-5ef5203299761"  
< Accept-Ranges: bytes  
< Content-Length: 20  
< Content-Type: text/html  
< 
<h1>it worked!</h1>  
* Connection #0 to host 10.0.2.15 left intact  

4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">  

vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://tyumen.leroymerlin.ru/  

###########################################################  
    testssl.sh       3.2rc2 from https://testssl.sh/dev/  
    (198bb09 2022-11-28 17:09:04)  

      This program is free software. Distribution and  
             modification under GPLv2 permitted.  
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!  

       Please file bugs @ https://testssl.sh/bugs/  

###########################################################  

 Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~179 ciphers]  
 on vagrant:./bin/openssl.Linux.x86_64  
 (built: "Sep  1 14:03:44 2022", platform: "linux-x86_64")  


 Start 2022-12-08 14:52:19        -->> 178.248.235.219:443 (tyumen.leroymerlin.ru) <<--  

 rDNS (178.248.235.219): --  
 Service detected:       HTTP  


 Testing vulnerabilities   

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension  
 CCS (CVE-2014-0224)                       not vulnerable (OK)  
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)  
 ROBOT                                     not vulnerable (OK)  
 Secure Renegotiation (RFC 5746)           supported (OK)  
 Secure Client-Initiated Renegotiation     not vulnerable (OK)  
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)  
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested  
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)  
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)  
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers  
 FREAK (CVE-2015-0204)                     not vulnerable (OK)  
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)  
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services, see  
                                           https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=E2CFC74D94CDA66B11DE1285E73F37D1A396F7AA640210AF0E688AA942C61F90  
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2  
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA AES128-SHA DES-CBC3-SHA   
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)  
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches  
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)  
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)  


 Done 2022-12-08 14:52:48 [  31s] -->> 178.248.235.219:443 (tyumen.leroymerlin.ru) <<--  

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/5-1.png"
  alt="image 5-1.png"
  title="image 5-1.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px"> 

vagrant@vagrant:~$ systemctl status sshd.service  
? ssh.service - OpenBSD Secure Shell server  
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)  
     Active: active (running) since Thu 2022-12-08 14:06:58 UTC; 52min ago  
       Docs: man:sshd(8)  
             man:sshd_config(5)  
   Main PID: 706 (sshd)  
      Tasks: 1 (limit: 2240)  
     Memory: 6.6M  
        CPU: 70ms  
     CGroup: /system.slice/ssh.service  
             L-706 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"  

Dec 08 14:06:58 vagrant systemd[1]: Starting OpenBSD Secure Shell server...  
Dec 08 14:06:58 vagrant sshd[706]: Server listening on 0.0.0.0 port 22.  
Dec 08 14:06:58 vagrant systemd[1]: Started OpenBSD Secure Shell server.  
Dec 08 14:06:58 vagrant sshd[706]: Server listening on :: port 22.  
Dec 08 14:07:03 vagrant sshd[1289]: Accepted publickey for vagrant from 10.0.2.2 port 50605 ssh2: RSA SHA256:zhvDy3fBvEETKQg/nDA4AFLvti+KR/83bfDp3DPG4iI  
Dec 08 14:07:03 vagrant sshd[1289]: pam_unix(sshd:session): session opened for user vagrant(uid=1000) by (uid=0)  
Dec 08 14:07:08 vagrant sshd[1702]: ssh_dispatch_run_fatal: Connection from 10.0.2.2 port 50574: Broken pipe [preauth]  
Dec 08 14:08:46 vagrant sshd[1713]: Accepted password for vagrant from 10.0.2.2 port 50875 ssh2  
Dec 08 14:08:46 vagrant sshd[1713]: pam_unix(sshd:session): session opened for user vagrant(uid=1000) by (uid=0)  

vagrant@vagrant:~$ ssh-keygen  
Generating public/private rsa key pair.  
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):   
Enter passphrase (empty for no passphrase):   
Enter same passphrase again:   
Your identification has been saved in /home/vagrant/.ssh/id_rsa  
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub  
The key fingerprint is:  
SHA256:4fIUOx5UubUjO0ThpJtyAvBRcgwlrdZCxM5k5gvfr5I vagrant@vagrant  
The key's randomart image is:  
+---[RSA 3072]----+  
|  .o**+   +o     |  
|   o*=o  =o .    |  
|   Ooo  =..o .   |  
|  . B..o *+ o    |  
|   + ++ S. o .   |  
|    o .O oo      |  
|     . .o  .     |  
|    E   .        |  
|     ...         |  
+----[SHA256]-----+  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/5-2.png"
  alt="image 5-2.png"
  title="image 5-2.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">

vagrant@vagrant:~$ ssh-copy-id vagrant@10.0.2.200  
vagrant@vagrant:~$ ssh vagrant@10.0.2.200  

6. Переименуйте файлы ключей из задания 5.    

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">  

vagrant@vagrant:~$ sudo mv ~/.ssh/id_rsa ~/.ssh/new_rsa  
vagrant@vagrant:~$ sudo nano ~/.ssh/config  

Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.  

Host vagrant_fs  
     HostName 10.0.2.200  
     User vagrant  
     IdentityFile ~/.ssh/new_rsa  

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_sec/images/7.png"
  alt="image 7.png"
  title="image 7.png"
  style="display: inline-block; margin: 0 auto; max-width: 800px">  

vagrant@vagrant:~$ sudo tcpdump -c 100 -w 100.pcap -i eth0  
tcpdump: listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes  
100 packets captured  
101 packets received by filter  
0 packets dropped by kernel  


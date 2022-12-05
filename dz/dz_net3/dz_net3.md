Домашнее задание к занятию "3.8 Компьютерные сети (лекция 3)"  

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP  (image 1.png) 

route-views>show ip route 178.47.177.131  
Routing entry for 178.47.160.0/19  
  Known via "bgp 6447", distance 20, metric 0  
  Tag 3303, type external  
  Last update from 217.192.89.50 2w3d ago  
  Routing Descriptor Blocks:  
  * 217.192.89.50, from 217.192.89.50, 2w3d ago  
      Route metric is 0, traffic share count is 1  
      AS Hops 2  
      Route tag 3303  
      MPLS label: none  
route-views>show bgp 178.47.177.131  
BGP routing table entry for 178.47.160.0/19, version 2560897091  
Paths: (22 available, best #21, table default)  
  Not advertised to any peer  
  Refresh Epoch 1  
  3333 1103 12389  
    193.0.0.56 from 193.0.0.56 (193.0.0.56)  
      Origin IGP, localpref 100, valid, external  
      path 7FE0E300A5C8 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3267 12389  
    194.85.40.15 from 194.85.40.15 (185.141.126.1)  
      Origin IGP, metric 0, localpref 100, valid, external  
      path 7FE169178580 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  7018 3356 12389  
    12.0.1.63 from 12.0.1.63 (12.0.1.63)  
      Origin IGP, localpref 100, valid, external  
      Community: 7018:5000 7018:37232  
      path 7FE027430FB8 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  701 5511 12389  
    137.39.3.55 from 137.39.3.55 (137.39.3.55)  
      Origin IGP, localpref 100, valid, external  
      path 7FE132C9F818 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  8283 1299 12389  
    94.142.247.3 from 94.142.247.3 (94.142.247.3)  
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 1299:30000 8283:1 8283:101 8283:102  
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x24  
        value 0000 205B 0000 0000 0000 0001 0000 205B  
              0000 0005 0000 0001 0000 205B 0000 0005  
              0000 0002   
      path 7FE170349C88 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  57866 3356 12389  
    37.139.139.17 from 37.139.139.17 (37.139.139.17)  
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:901 3356:2065 57866:100 65100:3356 65103:1 65104:31  
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x30  
        value 0000 E20A 0000 0064 0000 0D1C 0000 E20A  
              0000 0065 0000 0064 0000 E20A 0000 0067  
              0000 0001 0000 E20A 0000 0068 0000 001F  
              
      path 7FE03246B138 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  49788 12552 12389  
    91.218.184.60 from 91.218.184.60 (91.218.184.60)  
      Origin IGP, localpref 100, valid, external  
      Community: 12552:12000 12552:12100 12552:12101 12552:22000  
      Extended Community: 0x43:100:0  
      path 7FE07CEDC2B8 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  20912 3257 3356 12389  
    212.66.96.126 from 212.66.96.126 (212.66.96.126)  
      Origin IGP, localpref 100, valid, external  
      Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004  
      path 7FE1CA30B548 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3356 12389  
    4.68.4.46 from 4.68.4.46 (4.69.184.201)  
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:901 3356:2065  
      path 7FE0F4A18250 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  7660 2516 12389  
    203.181.248.168 from 203.181.248.168 (203.181.248.168)  
      Origin IGP, localpref 100, valid, external  
      Community: 2516:1050 7660:9001  
      path 7FE0B9D33338 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3549 3356 12389  
    208.51.134.254 from 208.51.134.254 (67.16.168.191)  
      Origin IGP, metric 0, localpref 100, valid, external  
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:901 3356:2065 3549:2581 3549:30840  
      path 7FE0DDBF7EC8 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3561 3910 3356 12389  
    206.24.210.80 from 206.24.210.80 (206.24.210.80)  
      Origin IGP, localpref 100, valid, external  
      path 7FE109FF1858 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  101 3356 12389  
    209.124.176.223 from 209.124.176.223 (209.124.176.223)  
      Origin IGP, localpref 100, valid, external  
      Community: 101:20100 101:20110 101:22100 3356:2 3356:22 3356:100 3356:123 3356:501 3356:901 3356:2065  
      Extended Community: RT:101:22100  
      path 7FE0ABBD57A0 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  19214 3257 3356 12389  
    208.74.64.40 from 208.74.64.40 (208.74.64.40)  
      Origin IGP, localpref 100, valid, external  
      Community: 3257:8108 3257:30048 3257:50002 3257:51200 3257:51203  
      path 7FE15F090EC8 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 2  
  2497 12389  
    202.232.0.2 from 202.232.0.2 (58.138.96.254)  
      Origin IGP, localpref 100, valid, external  
      path 7FE13038BD60 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  4901 6079 1299 12389  
    162.250.137.254 from 162.250.137.254 (162.250.137.254)  
      Origin IGP, localpref 100, valid, external  
      Community: 65000:10100 65000:10300 65000:10400  
      path 7FE0B4EC0AA0 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  20130 6939 12389  
    140.192.8.16 from 140.192.8.16 (140.192.8.16)  
      Origin IGP, localpref 100, valid, external  
      path 7FE1552B7888 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  852 3356 12389  
    154.11.12.212 from 154.11.12.212 (96.1.209.43)  
      Origin IGP, metric 0, localpref 100, valid, external  
      path 7FE09668DF08 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  1351 6939 12389  
    132.198.255.253 from 132.198.255.253 (132.198.255.253)  
      Origin IGP, localpref 100, valid, external  
      path 7FE03D4CAD18 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  6939 12389  
    64.71.137.241 from 64.71.137.241 (216.218.252.164)  
      Origin IGP, localpref 100, valid, external  
      path 7FE1622866A8 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
  Refresh Epoch 1  
  3303 12389  
    217.192.89.50 from 217.192.89.50 (138.187.128.158)  
      Origin IGP, localpref 100, valid, external, best  
      Community: 3303:1004 3303:1006 3303:1030 3303:3056  
      path 7FE10A334D08 RPKI State valid  
      rx pathid: 0, tx pathid: 0x0  
  Refresh Epoch 1  
  3257 3356 12389  
    89.149.178.10 from 89.149.178.10 (213.200.83.26)  
      Origin IGP, metric 10, localpref 100, valid, external  
      Community: 3257:8794 3257:30043 3257:50001 3257:54900 3257:54901  
      path 7FE11E465D10 RPKI State valid  
      rx pathid: 0, tx pathid: 0  
	  
	  
2. Создайте dummy0 интерфейс в Ubuntu.  (image 2-1.png, image 2-2.png, image 2-3.png)

vagrant@vagrant:~$ sudo modprobe -v dummy numdummies=3  
insmod /lib/modules/5.15.0-30-generic/kernel/drivers/net/dummy.ko numdummies=0 numdummies=3  
vagrant@vagrant:~$ lsmod | grep dummy  
dummy                  16384  0  
vagrant@vagrant:~$ ifconfig -a | grep dummy  
dummy0: flags=130<BROADCAST,NOARP>  mtu 1500  
dummy1: flags=130<BROADCAST,NOARP>  mtu 1500  
dummy2: flags=130<BROADCAST,NOARP>  mtu 1500  

Добавьте несколько статических маршрутов.  

vagrant@vagrant:~$ sudo ip addr add 192.168.0.200/24 dev dummy0  
vagrant@vagrant:~$ sudo ip addr add 192.168.0.201/24 dev dummy1  
vagrant@vagrant:~$ sudo ip addr add 192.168.0.202/24 dev dummy2  
vagrant@vagrant:~$ ip a show type dummy  
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000  
    link/ether 4e:3d:6a:59:61:00 brd ff:ff:ff:ff:ff:ff  
    inet 192.168.0.200/24 scope global dummy0  
       valid_lft forever preferred_lft forever  
4: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000  
    link/ether c2:3c:6c:ec:c1:30 brd ff:ff:ff:ff:ff:ff  
    inet 192.168.0.201/24 scope global dummy1  
       valid_lft forever preferred_lft forever  
5: dummy2: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000  
    link/ether ce:4c:b2:d0:2b:0a brd ff:ff:ff:ff:ff:ff  
    inet 192.168.0.202/24 scope global dummy2  
       valid_lft forever preferred_lft forever  

Проверьте таблицу маршрутизации.  

vagrant@vagrant:~$ ip -br route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100   
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100   
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100   
10.0.2.3 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100   
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.200   
vagrant@vagrant:~$   

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.  (image 3.png)  

vagrant@vagrant:~$ sudo netstat -ntlp | grep LISTEN  
tcp        0      0 127.0.0.1:8125          0.0.0.0:*               LISTEN      645/netdata           
tcp        0      0 0.0.0.0:19999           0.0.0.0:*               LISTEN      645/netdata           
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      625/systemd-resolve   
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      704/sshd: /usr/sbin   
tcp6       0      0 :::9100                 :::*                    LISTEN      647/node_exporter     
tcp6       0      0 :::22                   :::*                    LISTEN      704/sshd: /usr/sbin   
vagrant@vagrant:~$ 

8125, 19999 - netdata  
22 - ssh  

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?  (image 4.png)  

vagrant@vagrant:~$ netstat -n --udp --listen  
Active Internet connections (only servers)  
Proto Recv-Q Send-Q Local Address           Foreign Address         State        
udp        0      0 127.0.0.1:8125          0.0.0.0:*                            
udp        0      0 127.0.0.53:53           0.0.0.0:*                            
udp        0      0 10.0.2.15:68            0.0.0.0:*                            

8125 - netdata  
53 - DNS  
68 - DHCP  

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.  (image 5.png)  

https://viewer.diagrams.net/?tags=%7B%7D&target=blank&highlight=0000ff&edit=_blank&layers=1&nav=1&title=5.drawio#R7Vptb5swEP41%2BbgIMObl45ruTWukaJv28qlywCFWDc4cp0n262cSQwATRJsE0m5VW9l3Z2zueXy%2BsxiAUbz5wNFiPmYhpgPLCDcDcDuwLNO2rEH6a4TbvcT1nL0g4iRURgfBV%2FIHK6GhpCsS4mXJUDBGBVmUhQFLEhyIkgxxztZlsxmj5VkXKMKa4GuAqC79QUIxV1LTMA6Kj5hEczW1B5ViioKHiLNVouZLWIL3mhhlj1GmyzkK2bogAu8GYMQZE%2FtWvBlhmro189h%2B3Psj2nzJHCeizQDHx8EMzwIY2Ca2reCNesIjoivlBrVQsc38QuKd427mIqZSYsomRVNMb%2FLXHjHK%2BM4YzHY%2F0kSNuiVxJJdDyVT%2BDyhZ3CMuZDPBYs34A0lS7Q%2FCMcXL5f0XthKY35uWt5F%2Fw4XUgpvdFDhUU%2BceNGQnYDEJVHspOHvIkZOevZmxRCiaZa9V9FT26pgLvCmIlOc%2BYBZjwbfSRGltV6GoCG45qr8%2B0MVTonmRKEqGFEGj%2FMkHpGRDgdUSOEsD7lMifSf92gOAI8pW4WVgU2udsCURhCVSGOD0RaUiRY7I%2FXtXMRBsIbWIkqjW%2FK1STJkQLJaKC1DDtHukhulrFMChDHWquwtPRXyMVtxQw3ASvk2D7UFSj%2BB7FBOaeuM75iFKUOv9KBCPsGhmffo6jbDIeIIEeSxH9jonq6ETRuQycjihWdnpfgWnJVvxAKtRFajyZTwPPVvb2N%2FQlHa1reXWXKQxeCnbZIIutKnPsOG8MkL5Buxjw0ENssmoe7jGLCGC8ftvbH29Z2geGBVuwO8RN0fHjZPdadE5eGrilwIb7PN88zTYxmxKKO4GNSFTVen8eJXIZGKXcaSRci7PwmsFD%2Fr9xUrz7i56HDmj32CVfB6PrSn%2FM6kpOl5zvNSAqoHzKHYAVLCDPWOn1x16sqmliAUMy2mn9ALf%2Fkw7Q5h1fynLXed2U7S83Wa9DRGFYbL3q6A5DEo72Zja1LF2a%2B2zu%2BZDozFNhfWYFjCDNZhlslOTV6tMGQe0S171B1WKGlgl1d4H58iCa6kGzku1zijTFPMaaXMkFPynzZNooxdQZ4lQZjE%2BFcLVkQh1pmjThja9RhtQKcSclqWyThsDDiXpTOh6vu0Cxy89FsBuSaSXdC8j9hy7TrjeuAMq2alrPJdAZiOBnG4JpNeW5yGQbYIihYaG4TTSqJBhuU9OsSaYE%2BmI9Pr0nJz0rp2TtlHhpPlcTlqNnHS75aSrcfLVF84nFV9OJZOxQc%2FF1z9483ESgG71trHvmw%2F%2FP4BPA7CSHFgdXhfXl3HGhc51q31meKwkcS9TkzQdJdd7hDsADA27HL49mT55zzzIq5Gk43rEbPGhRl%2B865B2V585OrZOO%2F8E2sEK7TquYswsiJ%2BZdqUSJqfg02hndcg7%2F%2Bp5BzXeQeME3jlHEqeTeSe7h8%2Fd9uaHzwnBu78%3D
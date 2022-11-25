Домашнее задание к занятию "3.5. Файловые системы"  

1. Узнайте о sparse (разряженных) файлах.  

Разреженные – это специальные файлы, которые с большей эффективностью используют файловую систему, они не позволяют ФС занимать свободное дисковое пространство носителя, когда разделы не заполнены. То есть, «пустое место» будет задействовано только при необходимости. Пустая информация в виде нулей, будет хранится в блоке метаданных ФС. Поэтому, разреженные файлы изначально занимают меньший объем носителя, чем их реальный объем.  

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?  

Нет. У жёстких ссылок, указывающих на один inode, одинаковые владелец и права доступа. Чтобы иметь возможность создать хардлинк на файл, нужно быть или его владельцем, или иметь как минимум rw-доступ.  

3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:  

vagrant destroy не делал, т.к. когда начал задание, прошлые домашки были на проверке. Вдруг пришлось бы в низ что-нибудь доделывать. Создал вторую виртуальную машину vagrant. (image 3-1.png, image 3-2.png)

vagrant@sysadm-fs:~$ lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS  
loop0                       7:0    0 61.9M  1 loop /snap/core20/1405  
loop1                       7:1    0 79.9M  1 loop /snap/lxd/22923  
loop2                       7:2    0 44.7M  1 loop /snap/snapd/15534  
sda                         8:0    0   64G  0 disk   
├─sda1                      8:1    0    1M  0 part   
├─sda2                      8:2    0    2G  0 part /boot  
└─sda3                      8:3    0   62G  0 part   
  └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /  
sdb                         8:16   0  2.5G  0 disk   
sdc                         8:32   0  2.5G  0 disk   
  
4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.  (image 4-1.png)  

vagrant@sysadm-fs:~$ sudo fdisk /dev/sdb

Command (m for help): F  
Unpartitioned space /dev/sdb: 2.5 GiB, 2683305984 bytes, 5240832 sectors  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  

Start     End Sectors  Size  
 2048 5242879 5240832  2.5G  

Command (m for help): n  
Partition type  
   p   primary (0 primary, 0 extended, 4 free)  
   e   extended (container for logical partitions)  
Select (default p): p  
Partition number (1-4, default 1):   
First sector (2048-5242879, default 2048):  
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G  

Created a new partition 1 of type 'Linux' and of size 2 GiB.  

Command (m for help): n  
Partition type  
   p   primary (1 primary, 0 extended, 3 free)  
   e   extended (container for logical partitions)  
Select (default p): p  
Partition number (2-4, default 2):   
First sector (4196352-5242879, default 4196352):   
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):   

Created a new partition 2 of type 'Linux' and of size 511 MiB.  

Command (m for help): w  
The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.  

vagrant@sysadm-fs:~$ lsblk  (image 4-2.png)  
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS  
loop0                       7:0    0 61.9M  1 loop /snap/core20/1405  
loop1                       7:1    0 79.9M  1 loop /snap/lxd/22923  
loop2                       7:2    0 44.7M  1 loop /snap/snapd/15534  
loop3                       7:3    0 49.6M  1 loop /snap/snapd/17576  
loop4                       7:4    0 63.2M  1 loop /snap/core20/1695  
loop5                       7:5    0  103M  1 loop /snap/lxd/23541  
sda                         8:0    0   64G  0 disk   
+-sda1                      8:1    0    1M  0 part   
+-sda2                      8:2    0    2G  0 part /boot  
L-sda3                      8:3    0   62G  0 part   
  L-ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /  
sdb                         8:16   0  2.5G  0 disk   
+-sdb1                      8:17   0    2G  0 part   
L-sdb2                      8:18   0  511M  0 part   
sdc                         8:32   0  2.5G  0 disk   


5. Используя sfdisk, перенесите данную таблицу разделов на второй диск. (image 5.png)   

vagrant@sysadm-fs:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc   
...  
vagrant@sysadm-fs:~$ lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
...  
sdb                         8:16   0  2.5G  0 disk   
+-sdb1                      8:17   0    2G  0 part   
L-sdb2                      8:18   0  511M  0 part   
sdc                         8:32   0  2.5G  0 disk   
+-sdc1                      8:33   0    2G  0 part   
L-sdc2                      8:34   0  511M  0 part   

6. Соберите mdadm RAID1 на паре разделов 2 Гб.  (image 6.png)  

vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1  
mdadm: Note: this array has metadata at the start and  
    may not be suitable as a boot device.  If you plan to  
    store '/boot' on this device please ensure that  
    your boot-loader understands md/v1.x metadata, or use  
    --metadata=0.90  
mdadm: size set to 2094080K  
Continue creating array? (y/n) y  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md0 started.  

vagrant@sysadm-fs:~$ lsblk  
...  
sdb                         8:16   0  2.5G  0 disk    
+-sdb1                      8:17   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
L-sdb2                      8:18   0  511M  0 part    
sdc                         8:32   0  2.5G  0 disk    
+-sdc1                      8:33   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
L-sdc2                      8:34   0  511M  0 part    

7. Соберите mdadm RAID0 на второй паре маленьких разделов.  (image 7.png)  

vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sdb2 /dev/sdc2  
...  
sdb                         8:16   0  2.5G  0 disk    
+-sdb1                      8:17   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
L-sdb2                      8:18   0  511M  0 part    
  L-md1                     9:1    0 1018M  0 raid0   
sdc                         8:32   0  2.5G  0 disk    
+-sdc1                      8:33   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
L-sdc2                      8:34   0  511M  0 part    
  L-md1                     9:1    0 1018M  0 raid0   

8. Создайте 2 независимых PV на получившихся md-устройствах.  (image 8.png)  

vagrant@sysadm-fs:~$ sudo pvcreate /dev/md0  
  Physical volume "/dev/md0" successfully created.  
vagrant@sysadm-fs:~$ sudo pvcreate /dev/md1  
  Physical volume "/dev/md1" successfully created.  

9. Создайте общую volume-group на этих двух PV.  (image 9.png)  

vagrant@sysadm-fs:~$ sudo vgcreate new-vg /dev/md0 /dev/md1  
  Volume group "new-vg" successfully created  

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.  (image 10.png)   

vagrant@sysadm-fs:~$ sudo lvcreate -L 100M -n new-lv new-vg /dev/md1  
  Logical volume "new-lv" created.  
  
11. Создайте mkfs.ext4 ФС на получившемся LV.  (image 11.png)  

vagrant@sysadm-fs:~$ sudo mkfs.ext4 /dev/new-vg/new-lv  
mke2fs 1.46.5 (30-Dec-2021)  
Creating filesystem with 25600 4k blocks and 25600 inodes  

Allocating group tables: done                             
Writing inode tables: done                            
Creating journal (1024 blocks): done  
Writing superblocks and filesystem accounting information: done  

12. Смонтируйте этот раздел в любую директорию, например, /tmp/new   (image 12.png)  

vagrant@sysadm-fs:~$ mkdir /tmp/new  
vagrant@sysadm-fs:~$ sudo mount /dev/new-vg/new-lv /tmp/new  

13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.  (image 13.png)  

vagrant@sysadm-fs:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-11-24 15:02:31--  https://mirror.yandex.ru/ubuntu/ls-lR.gz  
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183  
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.  
HTTP request sent, awaiting response... 200 OK  
Length: 23596903 (23M) [application/octet-stream]  
Saving to: ‘/tmp/new/test.gz’  

/tmp/new/test.gz                                            100%[=======================================================  

2022-11-24 15:02:36 (4.73 MB/s) - ‘/tmp/new/test.gz’ saved [23596903/23596903]  

14. Прикрепите вывод lsblk (image 14.png)  

vagrant@sysadm-fs:~$ lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS  
loop0                       7:0    0 61.9M  1 loop  /snap/core20/1405  
loop1                       7:1    0 79.9M  1 loop  /snap/lxd/22923  
loop2                       7:2    0 44.7M  1 loop  /snap/snapd/15534  
loop3                       7:3    0 49.6M  1 loop  /snap/snapd/17576  
loop4                       7:4    0 63.2M  1 loop  /snap/core20/1695  
loop5                       7:5    0  103M  1 loop  /snap/lxd/23541  
sda                         8:0    0   64G  0 disk    
+-sda1                      8:1    0    1M  0 part    
+-sda2                      8:2    0    2G  0 part  /boot  
L-sda3                      8:3    0   62G  0 part    
  L-ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /  
sdb                         8:16   0  2.5G  0 disk    
+-sdb1                      8:17   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
L-sdb2                      8:18   0  511M  0 part    
  L-md1                     9:1    0 1018M  0 raid0   
    L-new--vg-new--lv     253:1    0  100M  0 lvm   /tmp/new  
sdc                         8:32   0  2.5G  0 disk    
+-sdc1                      8:33   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
L-sdc2                      8:34   0  511M  0 part    
  L-md1                     9:1    0 1018M  0 raid0   
    L-new--vg-new--lv     253:1    0  100M  0 lvm   /tmp/new  

15. Протестируйте целостность файла: (image 15.png)   

vagrant@sysadm-fs:~$ sudo gzip -t /tmp/new/test.gz  
vagrant@sysadm-fs:~$ echo $?  
0  

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1. (image 16.png)  

vagrant@sysadm-fs:~$ sudo pvmove /dev/md1 /dev/md0  
  /dev/md1: Moved: 20.00%  
  /dev/md1: Moved: 100.00%  
vagrant@sysadm-fs:~$   

sdb                         8:16   0  2.5G  0 disk    
+-sdb1                      8:17   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
¦   L-new--vg-new--lv     253:1    0  100M  0 lvm   /tmp/new  
L-sdb2                      8:18   0  511M  0 part    
  L-md1                     9:1    0 1018M  0 raid0   
sdc                         8:32   0  2.5G  0 disk    
+-sdc1                      8:33   0    2G  0 part    
¦ L-md0                     9:0    0    2G  0 raid1   
¦   L-new--vg-new--lv     253:1    0  100M  0 lvm   /tmp/new  
L-sdc2                      8:34   0  511M  0 part    
  L-md1                     9:1    0 1018M  0 raid0   

17. Сделайте --fail на устройство в вашем RAID1 md.  (image 17.png)  

vagrant@sysadm-fs:~$ sudo mdadm /dev/md0 --fail /dev/sdc1  
mdadm: set /dev/sdc1 faulty in /dev/md0  

18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.  (image 18.png)  

[ 3907.495388] md/raid1:md0: not clean -- starting background reconstruction  
[ 3907.495390] md/raid1:md0: active with 2 out of 2 mirrors  
[ 3907.495404] md0: detected capacity change from 0 to 4188160  
[ 3907.499560] md: resync of RAID array md0  
[ 3918.111695] md: md0: resync done.  
[ 4285.485241] md1: detected capacity change from 0 to 2084864  
[ 5689.568754] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.  
[ 6884.054722] dm-2: detected capacity change from 204800 to 8192  
[ 7414.593697] md/raid1:md0: Disk failure on sdc1, disabling device.  
               md/raid1:md0: Operation continuing on 1 devices.  
vagrant@sysadm-fs:~$   

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:  (image 19.png)   

vagrant@sysadm-fs:~$ sudo gzip -t /tmp/new/test.gz  
vagrant@sysadm-fs:~$ echo $?  
0  
vagrant@sysadm-fs:~$   

20. Погасите тестовый хост, vagrant destroy.

Пока оставил для экспериментов.  
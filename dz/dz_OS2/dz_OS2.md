Домашнее задание к занятию "3.3 Операционные системы (лекция 2)"  

1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:  

Cоздаем служебный файл Systemd для Node Exporter  

vagrant@vagrant:~$ sudo nano /etc/systemd/system/node_exporter.service  (image 1-1.png)  

[Unit]  
Description=Node Exporter  
Wants=network-online.target  
After=network-online.target  

[Service]  
User=node_exporter  
Group=node_exporter  
Type=simple  
ExecStart=/usr/local/bin/node_exporter  

[Install]  
WantedBy=multi-user.target  

предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron)  
vagrant@vagrant:~$ sudo nano /etc/systemd/system/node_exporter.service  
ExecStart=/usr/local/bin/node_exporter $EXTRA_OPTS   

Перезагружаю systemd для того, чтобы использовать только что созданную службу. Запускаю Node Exporter. Проверяю корректность работы.  (image 1-2.png)

vagrant@vagrant:~$ sudo systemctl daemon-reload  
vagrant@vagrant:~$ sudo systemctl start node_exporter  
vagrant@vagrant:~$ sudo systemctl status node_exporter  
автозапуск службы  
vagrant@vagrant:~$ sudo systemctl enable node_exporter  

После перезагрузки статус Active: active (running)

2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. (image 2-1.png)    

vagrant@vagrant:~$ curl http://localhost:9100/metrics

Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

CPU (пример для 1 ядра, если их больше, то надо для каждого)  
node_cpu_seconds_total{cpu="0",mode="idle"} 110.36  
node_cpu_seconds_total{cpu="0",mode="iowait"} 1.1  
node_cpu_seconds_total{cpu="0",mode="system"} 2.25  
node_cpu_seconds_total{cpu="0",mode="user"} 1.04  

Память  
node_memory_Buffers_bytes 2.7389952e+07  
node_memory_Cached_bytes 6.78252544e+08  
node_memory_HardwareCorrupted_bytes 0  
node_memory_MemAvailable_bytes 1.68921088e+09  
node_memory_MemFree_bytes 1.10473216e+09  
node_memory_MemTotal_bytes 2.073051136e+09  
node_memory_Mlocked_bytes 2.854912e+07  
node_memory_SwapFree_bytes 2.036330496e+09  
node_memory_SwapTotal_bytes 2.036330496e+09  

Диски  
node_disk_io_now{device="dm-0"} 2  
node_disk_io_now{device="sda"} 1  
node_disk_io_time_seconds_total{device="dm-0"} 7.296  
node_disk_io_time_seconds_total{device="sda"} 7.356  
node_disk_read_bytes_total{device="dm-0"} 6.18161152e+08  
node_disk_read_bytes_total{device="sda"} 6.27435008e+08  
node_disk_write_time_seconds_total{device="dm-0"} 0.48  
node_disk_write_time_seconds_total{device="sda"} 0.43  

Сеть  

node_network_receive_bytes_total{device="eth0"} 50134  
node_network_receive_bytes_total{device="lo"} 12005  
node_network_receive_errs_total{device="eth0"} 0  
node_network_receive_errs_total{device="lo"} 0  
node_network_receive_packets_total{device="eth0"} 448  
node_network_receive_packets_total{device="lo"} 221  
node_network_speed_bytes{device="eth0"} 1.25e+08  
node_network_transmit_bytes_total{device="eth0"} 53622  
node_network_transmit_bytes_total{device="lo"} 12005  
node_network_transmit_errs_total{device="eth0"} 0  
node_network_transmit_errs_total{device="lo"} 0  
node_network_transmit_packets_total{device="eth0"} 307  
node_network_transmit_packets_total{device="lo"} 221  
node_network_up{device="eth0"} 1  
node_network_up{device="lo"} 0  

3. Установите в свою виртуальную машину Netdata.  

Setting up netdata (1.36.1) ...
Installing new version of config file /etc/init.d/netdata ...  
Installing new version of config file /etc/logrotate.d/netdata ...  
Installing new version of config file /etc/netdata/edit-config ...  
Installing new version of config file /etc/netdata/netdata.conf ...  

После успешной установки:  
в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,  (image 3-1.png)  
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:  
config.vm.network "forwarded_port", guest: 19999, host: 19999  (image 3-2.png)  
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.  (image 3-3.png)  

4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  (image 4.png)  

Да, можно:  
vagrant@vagrant:~$ sudo dmesg  

[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006  
[    0.000000] Hypervisor detected: KVM  
[    0.000760] CPU MTRRs all blank - virtualized system.  

[    0.000903] ACPI: RSDP 0x00000000000E0000 000024 (v02 VBOX  )  
[    0.000906] ACPI: XSDT 0x000000007FFF0030 00003C (v01 VBOX   VBOXXSDT 00000001 ASL  00000061)  
[    0.000910] ACPI: FACP 0x000000007FFF00F0 0000F4 (v04 VBOX   VBOXFACP 00000001 ASL  00000061)  
[    0.000914] ACPI: DSDT 0x000000007FFF0620 002353 (v02 VBOX   VBOXBIOS 00000002 INTL 20100528)  
[    0.000917] ACPI: FACS 0x000000007FFF0200 000040  
[    0.000919] ACPI: FACS 0x000000007FFF0200 000040  
[    0.000921] ACPI: APIC 0x000000007FFF0240 00006C (v02 VBOX   VBOXAPIC 00000001 ASL  00000061)  
[    0.000924] ACPI: SSDT 0x000000007FFF02B0 00036C (v01 VBOX   VBOXCPUT 00000002 INTL 20100528)  

[    0.005540] Booting paravirtualized kernel on KVM  

[    1.404961] ata3.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133  

[    1.476375] vboxvideo: loading out-of-tree module taints kernel.  
[    1.476592] vboxvideo: module verification failed: signature and/or required key missing - tainting kernel  
[    1.477828] vboxvideo: loading version 6.1.34 r150636  
[    1.478005] vboxvideo 0000:00:02.0: vgaarb: deactivate vga console  

В этой цитате, я думаю, есть ответ:   

[    3.321972] systemd[1]: Detected virtualization oracle.  

5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Определите, что означает этот параметр.  (image 5.png)  

nr_open:  
Максимальное количество файловых дескрипторов, поддерживаемых ядром, то есть максимальное количество файловых дескрипторов, используемых процессом   
This denotes the maximum number of file-handles a process can allocate. Default value is 1024*1024 (1048576) which should be enough for most machines. Actual limit depends on RLIMIT_NOFILE resource limit.  

vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576
 

Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

vagrant@vagrant:~$ ulimit -Hn
1048576

6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.  

Долго ничего не получалось. Но посмотрел вопросы студентов, нашел ответ к этому заданию.  
Огромная благодарность Булату Замилову за Ответ эксперта: Попробуйте поработать с unshare и nsenter  (image 6.png)  

vagrant@vagrant:~$ sleep 1h  
^Z  
[1]+  Stopped                 sleep 1h  
vagrant@vagrant:~$ ps  
    PID TTY          TIME CMD  
   1718 pts/0    00:00:00 bash  
   1727 pts/0    00:00:00 sleep  
   1730 pts/0    00:00:00 ps  
vagrant@vagrant:~$ sudo -i  
root@vagrant:~# unshare -f --pid --mount-proc sleep 1h  
^Z  
[1]+  Stopped                 unshare -f --pid --mount-proc sleep 1h  
root@vagrant:~# ps  
    PID TTY          TIME CMD  
   1732 pts/1    00:00:00 sudo  
   1733 pts/1    00:00:00 bash  
   1747 pts/1    00:00:00 unshare  
   1748 pts/1    00:00:00 sleep  
   1749 pts/1    00:00:00 ps  
root@vagrant:~# nsenter --target 1748 --pid --mount  
root@vagrant:/# ps  
    PID TTY          TIME CMD  
      1 pts/1    00:00:00 sleep  
      2 pts/1    00:00:00 bash  
     12 pts/1    00:00:00 ps  
root@vagrant:/#   

7. Найдите информацию о том, что такое :(){ :|:& };:.  

Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться.  
Не знаю правильно или нет отработал скрипт. У меня Ubuntu 22.04. После запуска прождал минут 5, завершил процесс. (image 7-1.png)(image 7-2.png)  

Вызов dmesg расскажет, какой механизм помог автоматической стабилизации.  

Nov 20 15:32:40 vagrant systemd[1]: Started Session 11 of User vagrant.  
Nov 20 15:32:40 vagrant kernel: [ 1553.307747] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-11.scope  
Nov 20 15:32:40 vagrant systemd[1]: session-11.scope: Deactivated successfully.  
Nov 20 15:32:41 vagrant systemd[1]: Started Session 12 of User vagrant.  
Nov 20 15:32:41 vagrant kernel: [ 1554.147639] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-12.scope  
Nov 20 15:32:41 vagrant systemd[1]: session-12.scope: Deactivated successfully.  
Nov 20 15:32:48 vagrant systemd[1]: Started Session 13 of User vagrant.  
Nov 20 15:32:48 vagrant kernel: [ 1561.360801] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-13.scope  
Nov 20 15:32:48 vagrant systemd[1]: session-13.scope: Deactivated successfully.  

Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?  (image 7-3.png)  

Проверить свои пользовательские ограничения  
vagrant@vagrant:~$ ulimit -a  
real-time non-blocking time  (microseconds, -R) unlimited  
core file size              (blocks, -c) 0  
data seg size               (kbytes, -d) unlimited  
scheduling priority                 (-e) 0  
file size                   (blocks, -f) unlimited  
pending signals                     (-i) 7468  
max locked memory           (kbytes, -l) 253056  
max memory size             (kbytes, -m) unlimited  
open files                          (-n) 1024  
pipe size                (512 bytes, -p) 8  
POSIX message queues         (bytes, -q) 819200  
real-time priority                  (-r) 0  
stack size                  (kbytes, -s) 8192  
cpu time                   (seconds, -t) unlimited  
max user processes                  (-u) 7468  
virtual memory              (kbytes, -v) unlimited  
file locks                          (-x) unlimited  

Проверка Hard лимит  
vagrant@vagrant:~$ ulimit -Hn  
1048576  

Проверка Soft лимит  
vagrant@vagrant:~$ ulimit -Sn  
1024  

Изменение количества одновременно созданных в сессии процессов. Если правильно понял, ограничение только для этой сессии:  
 
vagrant@vagrant:~$ ulimit -u  
7468  
vagrant@vagrant:~$ ulimit -u 5000  
vagrant@vagrant:~$ ulimit -u  
5000  

Если вы хотите сделать более постоянное изменение, вам нужно отредактировать либо /etc/limits.conf либо /etc/security/limits.conf (в зависимости от дистрибутива Linux) и добавить следующие строки:  

username hard nproc 1000  
Замените username фактическим именем пользователя  

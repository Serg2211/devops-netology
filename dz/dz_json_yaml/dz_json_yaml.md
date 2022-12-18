Домашнее задание к занятию "4.3 Языки разметки JSON и YAML"  

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:  

```
{ "info" : "Sample JSON output from our service\t",  
    "elements" :[  
        { "name" : "first",  
        "type" : "server",  
        "ip" : 7175   
        },  
        { "name" : "second",  
        "type" : "proxy",  
        "ip : 71.78.22.43  
        }  
    ]  
}  
```

Нужно найти и исправить все ошибки, которые допускает наш сервис:

```
{  
    "info": "Sample JSON output from our service\t",  
    "elements": [  
      {  
        "name": "first",  
        "type": "server",  
        "ip": "7175"  
      },  
      {  
        "name": "second",  
        "type": "proxy",  
        "ip": "71.78.22.43"  
      }  
    ]  
}  
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_json_yaml/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.  

```
import socket  
import json  
import yaml  
import time  

sites = {'yandex.ru': '','market.yandex.ru': '','music.yandex.ru': ''}  

for site in sites:  
    ip = socket.gethostbyname(site)  
    sites[site] = ip  

with open("C:\Python\ip.json", "w") as fp_json:  
    json.dump(sites, fp_json, indent=2)  
with open("C:\Python\ip.yaml", "w") as fp_yaml:  
    yaml.dump(sites, fp_yaml, explicit_start=True, explicit_end=True)  

while True:  
    for site in sites:  
        ip = sites[site]  
        new_ip = socket.gethostbyname(site)  
        if new_ip != ip:  
            sites[site] = new_ip  
            print(f'[ERROR] {site} IP mismatch: {ip} {new_ip}')  
            with open("C:\Python\ip.json", "w") as fp_json:  
                json.dump(sites, fp_json, indent=2)  
            with open("C:\Python\ip.yaml", "w") as fp_yaml:  
                yaml.dump(sites, fp_yaml, explicit_start=True, explicit_end=True)  
        print(f'{site} IP: {new_ip}')  
    time.sleep(0.1)  
```

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_json_yaml/images/2-1.png"
  alt="image 2-1.png"
  title="image 2-1.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_json_yaml/images/2-2.png"
  alt="image 2-2.png"
  title="image 2-2.png"
  style="display: inline-block; margin: 0 auto; width: 400px">

Формат записи YAML по одному сервису: - имя сервиса: его IP.  

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/dz_json_yaml/images/2-3.png"
  alt="image 2-3.png"
  title="image 2-3.png"
  style="display: inline-block; margin: 0 auto; width: 400px">
Домашнее задание к занятию "9.3 Процессы CI/CD»  

Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.

```yaml
---
all:
  hosts:
    sonar-01:
      ansible_host: 158.160.61.155
    nexus-01:
      ansible_host: 158.160.56.42
  children:
    sonarqube:
      hosts:
        sonar-01:
    nexus:
      hosts:
        nexus-01:
    postgres:
      hosts:
        sonar-01:
  vars:
    ansible_connection_type: paramiko
    ansible_user: centos
```

3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.

```yaml
    - name: "Set up ssh key to access for managed node"
      authorized_key:
        user: "{{ sonarqube_db_user }}"
        state: present
        key: "{{ lookup('file', 'id_ed25519.pub') }}"
```

4. Запустите playbook, ожидайте успешного завершения.

```bash
sergo@ubuntu-pc:~/9.3/infrastructure$ ansible-playbook -i ./inventory/cicd/hosts.yml site.yml --diff

PLAY....
....
....
PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
sonar-01                   : ok=34   changed=16   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

sergo@ubuntu-pc:~/9.3/infrastructure$ 
```

5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).
6. Зайдите под admin\admin, поменяйте пароль на свой.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


## Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.

```bash
sergo@ubuntu-pc:~/9.3/sonar-scanner-4.8.0.2856-linux/jre/bin$ sonar-scanner --version
INFO: Scanner configuration file: /home/sergo/9.3/sonar-scanner-4.8.0.2856-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-69-generic amd64
sergo@ubuntu-pc:~/9.3/sonar-scanner-4.8.0.2856-linux/jre/bin$ 
```

5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.

```bash
sergo@ubuntu-pc:~/9.3/example$ sonar-scanner \
>   -Dsonar.projectKey=sonar_netology \
>   -Dsonar.sources=. \
>   -Dsonar.host.url=http://158.160.61.155:9000 \
>   -Dsonar.login=a0929b0074b6239edccf0fd089fc2004b3269125 \
>   -Dsonar.coverage.exclusions=fail.py
```

6. Посмотрите результат в интерфейсе.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


7. Исправьте ошибки, которые он выявил, включая warnings.

```py
def increment(index=0):
    index += 1
    return index
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))
```

8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.
9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">



## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/images/7.png"
  alt="image 7.png"
  title="image 7.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">


4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

[maven-metadata.xml](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/nexus/maven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.

```bash
sergo@ubuntu-pc:~/9.3/apache-maven-3.9.2$ mvn --version
Apache Maven 3.9.2 (c9616018c7a021c1c39be70fb2843d6f5f9b8a1c)
Maven home: /home/sergo/9.3/apache-maven-3.9.2
Java version: 11.0.19, vendor: Ubuntu, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: ru_RU, platform encoding: UTF-8
OS name: "linux", version: "5.15.0-69-generic", arch: "amd64", family: "unix"
sergo@ubuntu-pc:~/9.3/apache-maven-3.9.2$ 
```

5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.netology.app</groupId>
  <artifactId>simple-app</artifactId>
  <version>1.0-SNAPSHOT</version>
   <repositories>
    <repository>
      <id>my-repo</id>
      <name>maven-public</name>
      <url>http://158.160.56.42:8081/repository/maven-public/</url>
    </repository>
  </repositories>
  <dependencies>
      <dependency>
          <groupId>netology</groupId>
          <artifactId>java</artifactId>
          <version>8_282</version>
          <classifier>distrib</classifier>
          <type>tar.gz</type>
      </dependency>
  </dependencies>
</project>
```

2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.

```bash
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /home/sergo/9.3/mvn/target/simple-app-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  11.798 s
[INFO] Finished at: 2023-06-03T10:16:58Z
[INFO] ------------------------------------------------------------------------
[WARNING] 
[WARNING] Plugin validation issues were detected in 2 plugin(s)
[WARNING] 
[WARNING]  * org.apache.maven.plugins:maven-compiler-plugin:3.10.1
[WARNING]  * org.apache.maven.plugins:maven-resources-plugin:3.3.0
[WARNING] 
[WARNING] For more or less details, use 'maven.plugin.validation' property with one of the values (case insensitive): [BRIEF, DEFAULT, VERBOSE]
[WARNING] 
sergo@ubuntu-pc:~/9.3/mvn$ 
```

3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.

```bash
sergo@ubuntu-pc:~/.m2/repository/netology/java/8_282$ ls
java-8_282-distrib.tar.gz  java-8_282-distrib.tar.gz.sha1  java-8_282.pom.lastUpdated  _remote.repositories
sergo@ubuntu-pc:~/.m2/repository/netology/java/8_282$ 
```

4. В ответе пришлите исправленный файл `pom.xml`.

[pom.xml](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-03-cicd/mvn/pom.xml)

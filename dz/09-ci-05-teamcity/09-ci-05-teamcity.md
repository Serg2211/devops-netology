Домашнее задание к занятию "9.5 Teamcity»  

Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.

2. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.

3. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).

Создал через terraform все 3 машины. Через ansible развернул весь нужный софт (сделал не так как в видео).

[src](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/src)

[infrastructure](https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/infrastructure)

```bash
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

nexus_ip_address = "51.250.67.89"
teamcity-agent_ip_address = "51.250.91.154"
teamcity-server_ip_address = "84.201.157.247"
sergo@ubuntu-pc:~/9.5/src$ ssh sergo@51.250.67.89
sergo@fhmapfsp1vm6nd3c1v4r:~$ exit
logout
Connection to 51.250.67.89 closed.
sergo@ubuntu-pc:~/9.5/src$ ssh sergo@51.250.91.154
sergo@fhmmpmp355aqptpdsfe0:~$ exit
logout
Connection to 51.250.91.154 closed.
sergo@ubuntu-pc:~/9.5/src$ ssh sergo@84.201.157.247
sergo@fhm4lechv4cuqraga17f:~$ exit
logout
Connection to 84.201.157.247 closed.
sergo@ubuntu-pc:~/9.5/src$ 
```

```bash
sergo@ubuntu-pc:~/9.5/infrastructure2$ ansible-playbook -i ./inventory/cicd/hosts.yml site.yml --diff

PLAY [teamcity] *****************************************************************************************************************************************************************************************************************************************
...
...
...

*******************************************************************************************************************************************************************************************************************
ok: [nexus-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************************
nexus-01                   : ok=18   changed=11   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
teamcity-agent             : ok=12   changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
teamcity-server            : ok=12   changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

sergo@ubuntu-pc:~/9.5/infrastructure2$ 
```

4. Дождитесь запуска teamcity, выполните первоначальную настройку.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/1.png"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

4. Авторизуйте агент.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/2.png"
  alt="image 2.png"
  title="image 2.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).

[fork](https://github.com/Serg2211/example-teamcity)

## Основная часть

1. Создайте новый проект в teamcity на основе fork.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/3.png"
  alt="image 3.png"
  title="image 3.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

2. Сделайте autodetect конфигурации.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/4.png"
  alt="image 4.png"
  title="image 4.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

3. Сохраните необходимые шаги, запустите первую сборку master.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/5.png"
  alt="image 5.png"
  title="image 5.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

4. Поменяйте условия сборки: если сборка по ветке `main`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/6.png"
  alt="image 6.png"
  title="image 6.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/7.png"
  alt="image 7.png"
  title="image 7.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.

```xml
	<distributionManagement>
		<repository>
				<id>nexus</id>
				<url>http://51.250.67.89:8081/repository/maven-releases</url>
		</repository>
	</distributionManagement>
```

7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/8.png"
  alt="image 8.png"
  title="image 8.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

8. Мигрируйте `build configuration` в репозиторий.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/9.png"
  alt="image 9.png"
  title="image 9.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

9. Создайте отдельную ветку `feature/add_reply` в репозитории.

```bash
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git checkout -b feature/add_reply
Switched to a new branch 'feature/add_reply'
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity>
```

10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.

```java
package plaindoll;

public class Welcomer{
	public String sayWelcome() {
		return "Welcome home, good hunter. What is it your desire?";
	}
	public String sayFarewell() {
		return "Farewell, good hunter. May you find your worth in waking world.";
	}
	public String sayNeedGold() {
		return "Not enough gold";
	}
	public String saySome() {
		return "something in the way";
	}
	public String sayHunter() {
        return "Every hunter knows where the pheasant sits";
	}
}
```

11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.

```java
package plaindoll;

import static org.hamcrest.CoreMatchers.containsString;
import static org.junit.Assert.*;

import org.junit.Test;

public class WelcomerTest {
	
	private Welcomer welcomer = new Welcomer();

	@Test
	public void welcomerSaysWelcome() {
		assertThat(welcomer.sayWelcome(), containsString("Welcome"));
	}
	@Test
	public void welcomerSaysFarewell() {
		assertThat(welcomer.sayFarewell(), containsString("Farewell"));
	}
	@Test
	public void welcomerSaysHunter() {
		assertThat(welcomer.sayWelcome(), containsString("hunter"));
		assertThat(welcomer.sayFarewell(), containsString("hunter"));
	}
	@Test
	public void welcomerSaysSilver(){
		assertThat(welcomer.sayNeedGold(), containsString("gold"));
	}
	@Test
	public void welcomerSaysSomething(){
		assertThat(welcomer.saySome(), containsString("something"));
	}
	@Test
  public void welcomerGoodLuck(){
    assertThat(welcomer.sayHunter(), containsString("hunter"));
  }
}
```

12. Сделайте push всех изменений в новую ветку репозитория.

```bash
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git status
On branch feature/add_reply
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   src/main/java/plaindoll/Welcomer.java
        modified:   src/test/java/plaindoll/WelcomerTest.java

no changes added to commit (use "git add" and/or "git commit -a")
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git add --all                                           
warning: in the working copy of 'src/main/java/plaindoll/Welcomer.java', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/test/java/plaindoll/WelcomerTest.java', LF will be replaced by CRLF the next time Git touches it
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git commit -m "new metod and new test"                  
[feature/add_reply 0f01c9a] new metod and new test
 2 files changed, 6 insertions(+), 2 deletions(-)
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git push -f https://github.com/Serg2211/example-teamcity
Enumerating objects: 29, done.
Counting objects: 100% (29/29), done.
Delta compression using up to 16 threads
Compressing objects: 100% (15/15), done.
Writing objects: 100% (29/29), 2.84 KiB | 2.84 MiB/s, done.
Total 29 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3), done.
remote: 
remote: Create a pull request for 'feature/add_reply' on GitHub by visiting:
remote:      https://github.com/Serg2211/example-teamcity/pull/new/feature/add_reply
remote:
To https://github.com/Serg2211/example-teamcity
 * [new branch]      feature/add_reply -> feature/add_reply
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity>
```

13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/10.png"
  alt="image 10.png"
  title="image 10.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.

```bash
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git checkout main                                       
Switched to branch 'main'
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git merge feature/add_reply
Updating 70cb636..0f01c9a
Fast-forward
 src/main/java/plaindoll/Welcomer.java     | 7 +++++--
 src/test/java/plaindoll/WelcomerTest.java | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity> git push -f https://github.com/Serg2211/example-teamcity
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/Serg2211/example-teamcity
 + 5550fd1...0f01c9a main -> main (forced update)
PS C:\Users\sergo\YandexDisk\Study\Netology\example-teamcity>
```
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/11.png"
  alt="image 11.png"
  title="image 11.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/12.png"
  alt="image 12.png"
  title="image 12.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.

<img
  src="https://github.com/Serg2211/devops-netology/blob/main/dz/09-ci-05-teamcity/images/13.png"
  alt="image 13.png"
  title="image 13.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

19. В ответе пришлите ссылку на репозиторий.

---
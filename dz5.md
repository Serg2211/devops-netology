1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

git show aefea 

Ответ:

aefead2207ef7e2aa5dc81a34aedf0cad4c32545

Update CHANGELOG.md

2. Какому тегу соответствует коммит 85024d3?

git show 85024d3

Ответ:

commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

3.Сколько родителей у коммита b8d720? Напишите их хеши.

git show --pretty=format:' %P' b8d720

Ответ:

 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

git log  v0.12.23..v0.12.24  --oneline

Ответ:

33ff1c03bb (tag: v0.12.24) v0.12.24

b14b74c493 [Website] vmc provider links

3f235065b9 Update CHANGELOG.md

6ae64e247b registry: Fix panic when server is unreachable

5c619ca1ba website: Remove links to the getting started guide's old location

06275647e2 Update CHANGELOG.md

d5f9411f51 command: Fix bug when using terraform login on Windows

4b6d06cc5d Update CHANGELOG.md

dd01a35078 Update CHANGELOG.md

225466bc3e Cleanup after v0.12.23 release

5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

git log -S'func providerSource' --oneline

Ответ:

5af1e6234a main: Honor explicit provider_installation CLI config when present

8c928e8358 main: Consult local directories as potential mirrors of providers


6. Найдите все коммиты в которых была изменена функция globalPluginDirs.

git grep 'func globalPluginDirs'

Ответ:

plugins.go:func globalPluginDirs() []string {

Все коммиты в которых была изменена функция:

git log -L :'func globalPluginDirs':plugins.go --oneline 

Ответ:

78b12205587fe839f10d946ea3fdc06719decb05

52dbf94834cb970b510f2fba853a5b49ad9b1a46

41ab0aef7a0fe030e84018973a64135b11abcd70

66ebff90cdfaa6938f26f908c7ebad8d547fea17

8364383c359a6b738a436d1b7745ccdce178df47

7.Кто автор функции synchronizedWriters?

git log -S'func synchronizedWriters' --pretty=format:'%h - %an %ae'

Ответ:

bdfea50cc8 - James Bardin j.bardin@gmail.com

5ac311e2a9 - Martin Atkins mart@degeneration.co.uk
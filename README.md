#В этом файле мы прпописываем все, что должно игнорироваться: слова, буквосочетания, расширения и т.д.

#будут игнорироваться все файлы
**/.terraform/*
*.tfstate
*.tfstate.*
crash.log
crash.*.log

*.tfvars
*.tfvars.json

override.tf
override.tf.json
*_override.tf
*_override.tf.json

#будут игнорироваться все файлы 
.terraformrc
terraform.rc
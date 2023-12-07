###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh

variable "ssh_public_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdIInRB/adlxYGkzFFf2/xW/scO9Ri3H0KA6nPwRoLbba6OZUTrbGEMVzcsKYQk2sodcRShYv8rFCrcqcDyszNOnqmK/g+z2zrfdL3JLvKGVugY22fSPaQOxZBSjbeaOO6x4C1FOjNx3kzQbZzXDnOai4STeDrQb5PBFWmlsi9m1ZRsthCXdw+RRBZHAviXhn5OumMQzEOExLNckp1fX7WGNMyASY+OiWenLicRNwk60HdudxulolPdh2XRAFFXeT0VV0l6zfagAiWIfrNQFuhpSjMfp/E2Ej+omH+t2ztECwM+Bowc963V9jFFtqGFNZf02luUjizT5CpjQLh8aSVEdzvAgLvJu6HeTi49jbRYi2TUS9HpSP96HhJS+/wVFq4YsET+P9wiImx6bt8NZ0rf3+booR0+105VeVEiZ854iWTjJoKbq1AEBEaz/Zb6M8GBWC/h4/sq6MN0zUktnynvydy25Ps3UAldxhaldCcDMurznEfojVdwDN6l2YK+Vs= sergo@ubuntu-pc"
}

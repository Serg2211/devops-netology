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

###new vars
variable "vm_web_os" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS"
}

variable "vm_web_resource_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Resource name"
}

variable "vm_web_resource_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Resource platform_id"
}

variable "vm_web_resources" {
  type = map(any)
  default = {
    "cores" = 2
    "memory" = 2
    "core_fraction" = 5
  }
}

###ssh vars

variable "ssh-keys_and_serial-port-enable" {
  type = map(any)
  default = {
    "ssh-keys" = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOYZ2Hnfwqx8ze7U6Ebd9tlBKhWaECV5e1OmChYPkO1R"
    "serial-port-enable" = 1
  }
}

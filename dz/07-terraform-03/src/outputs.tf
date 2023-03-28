# output "description"{
# value = {
#     {
#     "name"       = yandex_compute_instance.dev[0].name
#     "id"         = yandex_compute_instance.dev[0].id
#     "fqdn"       = yandex_compute_instance.dev[0].fqdn
#     "public_ip"  = yandex_compute_instance.dev[0].network_interface[0].nat_ip_address
#     },
#     {
#     "name"       = yandex_compute_instance.dev[1].name
#     "id"         = yandex_compute_instance.dev[1].id
#     "fqdn"       = yandex_compute_instance.dev[1].fqdn
#     "public_ip"  = yandex_compute_instance.dev[1].network_interface[1].nat_ip_address
#     },
#     {
#     "name"       = yandex_compute_instance.web[0].name
#     "id"         = yandex_compute_instance.web[0].id
#     "fqdn"       = yandex_compute_instance.web[0].fqdn
#     "public_ip"  = yandex_compute_instance.web[0].network_interface[0].nat_ip_address
#     },
#     {
#     "name"       = yandex_compute_instance.web[1].name
#     "id"         = yandex_compute_instance.web[1].id
#     "fqdn"       = yandex_compute_instance.web[1].fqdn
#     "public_ip"  = yandex_compute_instance.web[1].network_interface[1].nat_ip_address
#     },
#     {
#     "name"       = yandex_compute_instance.test[0].name
#     "id"         = yandex_compute_instance.test[0].id
#     "fqdn"       = yandex_compute_instance.test[0].fqdn
#     "public_ip"  = yandex_compute_instance.test[0].network_interface[0].nat_ip_address
#     }
# }
# }


# data "yandex_compute_instance" "dev" {
#   depends_on = [yandex_compute_instance.dev]
#   for_each     = {
#     for i,vm in yandex_compute_instance.dev[*]:
#     vm.name => vm
#   }
#   name = "${each.value.name}"
# }
# data "yandex_compute_instance" "web" {
#   depends_on = [yandex_compute_instance.web]
#   for_each     = {
#     for i,vm in yandex_compute_instance.web[*]:
#     vm.name  => vm
#   }
#   name = "${each.value.name}"
# }
# data "yandex_compute_instance" "test" {
#   depends_on = [yandex_compute_instance.test]
#   for_each     = {
#     for i,vm in yandex_compute_instance.test[*]:
#     vm.name  => vm
#   }
#   name = "${each.value.name}"
# }

# output "dev" {
#   value =  [ for name in data.yandex_compute_instance.dev : ["name  = ${name.name}", "id = ${name.id}", "fqdn = ${name.fqdn}", "public_ip = ${name.network_interface[*].nat_ip_address}"]]
# }

# output "web" {
#   value = [for name in data.yandex_compute_instance.web : ["name  = ${name.name}", "id = ${name.id}", "fqdn = ${name.fqdn}", "public_ip = ${name.network_interface[*].nat_ip_address}"]]
# }

# output "test" {
#   value = [for name in data.yandex_compute_instance.test :  ["name  = ${name.name}", "id = ${name.id}", "fqdn = ${name.fqdn}", "public_ip = ${name.network_interface[*].nat_ip_address}"]]
# }

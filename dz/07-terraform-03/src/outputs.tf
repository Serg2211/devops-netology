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
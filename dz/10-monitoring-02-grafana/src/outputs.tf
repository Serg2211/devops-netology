output "grafana-server_ip_address" {
value = yandex_compute_instance.grafana-server.network_interface.0.nat_ip_address
description = "grafana-server external ip"
}
output "node-01_ip_address" {
value = yandex_compute_instance.node-01.network_interface.0.nat_ip_address
description = "node-01 external ip"
}
output "node-02_ip_address" {
value = yandex_compute_instance.node-02.network_interface.0.nat_ip_address
description = "node-02 external ip"
}

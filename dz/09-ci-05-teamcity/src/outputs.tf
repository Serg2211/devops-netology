output "teamcity-server_ip_address" {
value = yandex_compute_instance.teamcity-server.network_interface.0.nat_ip_address
description = "teamcity-server external ip"
}

output "teamcity-agent_ip_address" {
value = yandex_compute_instance.teamcity-agent.network_interface.0.nat_ip_address
description = "teamcity-agent external ip"
}

output "nexus_ip_address" {
value = yandex_compute_instance.nexus.network_interface.0.nat_ip_address
description = "nexus external ip"
}
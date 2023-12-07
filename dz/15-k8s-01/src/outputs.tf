output "vpc_name" {
  value = yandex_vpc_network.my-net.name
}

output "vpc_subnet_public_name" {
  value = yandex_vpc_subnet.public.name
}

output "vpc_subnet_private_name" {
  value = yandex_vpc_subnet.private.name
}

output "vpc_subnet_public_v4_cidr_blocks" {
  value = yandex_vpc_subnet.public.v4_cidr_blocks
}

output "vpc_subnet_private_v4_cidr_blocks" {
  value = yandex_vpc_subnet.private.v4_cidr_blocks
}

output "nat_instance_name" {
  value = yandex_compute_instance.nat-instance.name
}

output "nat_instance_ip_address" {
  value = yandex_compute_instance.nat-instance.network_interface.0.ip_address
}

output "public-vm_local_ip_address" {
  value = yandex_compute_instance.public-vm.network_interface.0.ip_address
}

output "public-vm_inet_ip_address" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

output "private-vm_local_ip_address" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}

output "private-vm_inet_ip_address" {
  value = yandex_compute_instance.private-vm.network_interface.0.nat_ip_address
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "app_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway_public_ip.ip_address
}
output "app_gateway_public_ip_id" {
  value = azurerm_public_ip.app_gateway_public_ip.id
}
output "private_sub_id" {
  value = azurerm_subnet.private_sub.id
}
output "private_sub_id_psql" {
  value = azurerm_subnet.private_sub_psql.id
}
output "public_sub_id" {
  value = azurerm_subnet.public_sub.id
}
output "public_cidr" {
  value = azurerm_subnet.public_sub.address_prefixes[0]
}
output "private_cidr" {
  value = azurerm_subnet.private_sub.address_prefixes[0]
}
output "private_cidr_psql" {
  value = azurerm_subnet.private_sub_psql.address_prefixes[0]
}
output "gateway_endpoint_fqdn" {
  value = azurerm_public_ip.app_gateway_public_ip.fqdn
}
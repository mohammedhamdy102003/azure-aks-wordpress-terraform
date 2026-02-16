output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
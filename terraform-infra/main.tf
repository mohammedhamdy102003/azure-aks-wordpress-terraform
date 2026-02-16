resource "azurerm_resource_group" "rg" {
  name     = "wp-final-project-rg"
  location = "westus2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "wp-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "wp-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_container_registry" "acr" {
  name                = "wpacr2026ultimate"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "wp-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "wpaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  # الجزء الجديد اللي هيحل المشكلة
  network_profile {
    network_plugin     = "kubenet"
    service_cidr       = "10.1.0.0/16" # بعيدة عن الـ 10.0 بتاع الـ VNet
    dns_service_ip     = "10.1.0.10"
  }

  depends_on = [azurerm_subnet.subnet]
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "wp-mysql-server-final"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "wpadmin"
  administrator_password = "P@ssw0rd1234!"
  sku_name               = "GP_Standard_D2ds_v4"
  version                = "8.0.21"

  storage {
    size_gb = 20
  }
}

resource "azurerm_mysql_flexible_database" "wp_db" {
  name                = "wordpressdb"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}
resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource   "azurerm_resource_group"   "rg"   { 
   count    = length(var.rgnames)
   name     ="rg${count.index}"
   location   =   "northeurope" 
 } 

 resource   "azurerm_virtual_network"   "myvnet"   { 
   count    = length(var.vnet_name)
   name     ="vnet2334${count.index}"
   address_space   =   ["10.0.0.0/16"]
   location   =   "northeurope" 
   resource_group_name   =  "rg${count.index}"
 } 

 resource   "azurerm_subnet"   "frontendsubnet"   { 
   count    = length(var.subnet_name)
   name     ="sbnet4546${count.index}"
   resource_group_name   =    "rg${count.index}"
   virtual_network_name   =   "vnet2334${count.index}" 
   address_prefix   =   "10.0.0.0/16"
 } 

 resource   "azurerm_public_ip"   "pip"   { 
   count    = length(var.pip)
   name     ="pip${count.index}"
   location   =   "northeurope" 
   resource_group_name   =  "rg${count.index}" 
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 } 

 resource   "azurerm_network_interface"   "myvm1nic"   { 
   count    = length(var.nic_name)
   name     ="nic0${count.index}"
   location   =   "northeurope" 
   resource_group_name   =   "rg${count.index}"

   ip_configuration   { 
     name   =   "ipconfig1" 
     subnet_id   =  "sbnet456457${count.index}"
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =   "pip${count.index}"
 }
 } 

 resource   "azurerm_windows_virtual_machine" "vm"{ 
  count    = length(var.vm_name)
   name     ="vm0567${count.index}"
   location                =   "northeurope" 
   resource_group_name     =   "rg${count.index}"
   network_interface_ids   =   ["nic0${count.index}"] 
    size                    =   "Standard_B1ms"
   admin_username          =   "testuser" 
   admin_password          =   "Giri@123456"

   source_image_reference   { 
     publisher   =   "MicrosoftWindowsServer" 
     offer       =   "WindowsServer" 
     sku         =   "2019-Datacenter" 
     version     =   "latest" 
   } 

   os_disk   { 
     caching             =   "ReadWrite" 
     storage_account_type   =   "Standard_LRS" 
   } 
 } 
 
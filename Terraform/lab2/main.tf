terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.23.0"
        }
        tls = {
            source = "hashicorp/tls"
            version = "4.0.3"
        }
        null = {
            source = "hashicorp/null"
            version = "3.1.1"
        }
        template = {
            source = "hashicorp/template"
            version = "2.2.0"
        }
    }
}

#we're using azure cloud
provider "azurerm" {
    features {}
    skip_provider_registration = true
}

provider "tls" {
    #configuration option
}
provider "null"{
    #configuration option
}

provider "template"{
    #configuration option
}

#VARS
#===============================

variable "resource_group_name" {}
variable "location" {}

#NETWORK
#===============================

resource "azurerm_virtual_network" "corp_prod_vnet" {
    name = "corp-prod-vnet"
    resource_group_name = var.resource_group_name
    location = var.location
    address_space = ["10.20.0.0/16"]

    tags = {
        environment = "Production Network"
    }
}

resource "azurerm_subnet" "private_subnet"{
    name = "private-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.corp_prod_vnet.name
    address_prefixes = ["10.20.10.0/24"]
}

resource "azurerm_network_interface" "webapp_nic"{
    name = "webapp-nic-${count.index + 1}"
    resource_group_name = var.resource_group_name
    location = var.location
    count = 2

    ip_configuration {
        name = "ipconfig-${count.index+1}"
        subnet_id = azurerm_subnet.private_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

#SECURITY
#================================

resource "azurerm_network_security_group" "webapp_nsg" {
  name                = "webapp-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "webapp_nsg_assoc" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.webapp_nsg.id
}

#SSH KEY
#=========================================

resource "tls_private_key" "linux_vm_sshkey" {
    algorithm="RSA"
    rsa_bits = 4096
}

resource "null_resource" "ssh_private_key"{
    triggers = {
        key = "${tls_private_key.linux_vm_sshkey.private_key_pem}"
    }
    provisioner "local-exec" {
        command = "echo '${tls_private_key.linux_vm_sshkey.private_key_pem}' > ./linux_vm_sshkey.pem"
    }
}

#VM
#==================================

data "template_cloudinit_config" "webapp_config" {
    gzip = true
    base64_encode = true

    part{
        content_type = "text/x-shellscript"
        content = <<-EOF
        #! /bin/bash
        apt-get -y update
        apt-get -y install nginx

        cd /var/www/html
        rm *.html
        git clone https://github.com/cloudacademy/webgl-globe/ .
        cp -a src/* .
        rm -rf {.git,*.md,src,conf.d,docs,Dockerfile,index.nginx-debian.html}

        systemctl restart nginx
        systemctl status nginx
        echo fin v1.00!
        EOF
    }
}

resource "azurerm_availability_set" "webapp_vm_availability_set" {
    name = "webapp_vm_availability_set"
    resource_group_name = var.resource_group_name
    location = var.location
    platform_fault_domain_count = 2
    platform_update_domain_count = 2
    managed = true
    tags = {
        environment = "Production"
    }
}

resource "azurerm_linux_virtual_machine" "webapp_linux_vm"{
    name = "webapp-linuxvm${count.index}"
    resource_group_name = var.resource_group_name
    location = var.location
    availability_set_id = azurerm_availability_set.webapp_vm_availability_set.id
    network_interface_ids = ["${element(azurerm_network_interface.webapp_nic.*.id,count.index)}"]
    size = "Standard_B1s"
    count = 2

    os_disk {
        name = "webapp-disk${count.index}"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference{
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-focal"
        sku = "20_04-lts-gen2"
        version = "latest"
    }

    computer_name = "webapp-linuxvm${count.index}"
    admin_username = "superadmin"
    disable_password_authentication = true

    admin_ssh_key{
        username = "superadmin"
        public_key = tls_private_key.linux_vm_sshkey.public_key_openssh
    }

    custom_data = data.template_cloudinit_config.webapp_config.rendered

    tags = {
        org = "CloudAcademy"
        environment = "Production"
    }
}

#LOADBALANCER
#================================

resource "azurerm_public_ip" "webapp_loadbalancer_pip" {
  name                = "webapp-loadbalancer-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    org = "CloudAcademy"
    environment = "Production"
  }
}

resource "azurerm_lb" "webapp_lb" {
  name                = "webapp-lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "webapp-frontend-ip"
    public_ip_address_id = azurerm_public_ip.webapp_loadbalancer_pip.id
  }

  tags = {
    org = "CloudAcademy"
    environment = "Production"
  }
}

resource "azurerm_lb_rule" "production-inbound-rules" {
  name                           = "http-inbound-rule"
  loadbalancer_id                = azurerm_lb.webapp_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "webapp-frontend-ip"
  probe_id                       = azurerm_lb_probe.http-inbound-probe.id
  backend_address_pool_ids       = ["${azurerm_lb_backend_address_pool.webapp-backend-pool.id}"]
}

resource "azurerm_lb_probe" "http-inbound-probe" {
  name            = "http-inbound-probe"
  loadbalancer_id = azurerm_lb.webapp_lb.id
  port            = 80
}

resource "azurerm_lb_backend_address_pool" "webapp-backend-pool" {
  name            = "webapp-backend-pool"
  loadbalancer_id = azurerm_lb.webapp_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "webapp_nic_backend_addr_pool_assoc" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.webapp_nic.*.id[count.index]
  ip_configuration_name   = azurerm_network_interface.webapp_nic.*.ip_configuration.0.name[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.webapp-backend-pool.id
}

#OUTPUT
#================================

output "load_balancer_ip" {
  value = azurerm_public_ip.webapp_loadbalancer_pip.ip_address
}

output "webapp_vm_private_ips" {
  value = azurerm_network_interface.webapp_nic.*.private_ip_address
}

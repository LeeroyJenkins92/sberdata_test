terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80le4b8gt2u33lvubr"
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

metadata = {
    user-data = "${file("/home/leej92/sberdata_test/Terraform/meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80le4b8gt2u33lvubr"
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

metadata = {
    user-data = "${file("/home/leej92/sberdata_test/Terraform/meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-11" {
  name = "network11"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-11.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.network-11.id}"

  labels = {
    my-label = "my-label-value"
  }

dynamic "ingress" {
  for_each = ["8080", "22"]
  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

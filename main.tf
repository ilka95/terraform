terraform {
  required_version = "= 1.1.4"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  #backend "s3" {
  #  endpoint   = "storage.yandexcloud.net"
  #  bucket     = "ilka95"
  #  region     = "ru-central1-a"
  #  key        = "issue1/lemp.tfstate"
  #  access_key = "jDlr_UIzvMOSE_pn2BiZ"
  #  secret_key = "rePZGlnP-mhuqcWSbZEoM46TK2i_NvnHFkn8TCjd"
  #
  #  skip_region_validation      = true
  #  skip_credentials_validation = true
  #}
}
//#provider
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

module "ya_instance_1" {
  source                = "./modules/instance"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
}

module "ya_instance_2" {
  source                = "./modules/instance"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet2.id
}
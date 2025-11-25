variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_cidr" {
  type    = string
  default = "172.16.0.0/24"  # 256 IPs for nodes
}

variable "pods_cidr" {
  type    = string
  default = "172.17.0.0/20"  # 4096 IPs for pods
}

variable "services_cidr" {
  type    = string
  default = "172.18.0.0/22"  # 1024 IPs for services
}

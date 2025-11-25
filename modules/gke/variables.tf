variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type    = string
  default = ""
}

variable "environment" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "master_cidr" {
  type    = string
  default = "172.19.0.0/28"
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "disk_size_gb" {
  type    = number
  default = 20
}

variable "node_count" {
  type    = number
  default = 1
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "master_authorized_cidr" {
  description = "CIDR block authorized to access the GKE master. Must be explicitly set - do not use 0.0.0.0/0 in production."
  type        = string
}

variable "use_spot" {
  type    = bool
  default = true
}

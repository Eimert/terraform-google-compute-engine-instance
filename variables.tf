variable "region" {}
variable "zone" {}

variable "amount" {}
variable "name_prefix" {}
variable "machine_type" {}
variable "user_data" {}

variable "disk_type" {
  default = "pd-standard" # or pd-ssd
}

variable "disk_size" {}
variable "disk_image" {}

variable "disk_create_local_exec_command_or_fail" {
  default = ":"
}

variable "disk_create_local_exec_command_and_continue" {
  default = ":"
}

variable "disk_destroy_local_exec_command_or_fail" {
  default = ":"
}

variable "disk_destroy_local_exec_command_and_continue" {
  default = ":"
}

variable "automatic_restart" {
  default = "true"
}

variable "dns_zone_name" {
  # the DNS zone that is pointing to Google' nameservers (if any)
  # Google' DNS SOA (start of authority)
  # requires last dot.
  default = "cloud.example.com."
}

variable "dns_record_name" {
  # For example: "ansible-dev" will become ansible-dev.cloud.example.com
  default = "ansible-dev"
}

variable "username" {}
variable "public_key_path" {}

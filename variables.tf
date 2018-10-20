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

# variable "dns_zone_name" {
#  default = "dev_zone"
# }

var "dns_name" {
  # requires last dot.
  default = "dev.example.com."
}

variable "username" {}
variable "public_key_path" {}

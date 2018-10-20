variable "region" {
  description = "GC region"
  default = "europe-west4"
}

variable "zone" {
  description = "GC zone"
  default = "europe-west4-c"
}

variable "amount" {
  description = "Number of VMs"
  default = "1"
}
variable "name_prefix" {
  description = "hostname format: name_prefix-amount"
  default = "vm"
}
variable "machine_type" {
  description = "List of VM sizes: https://github.com/Eimert/terraform-google-compute-engine-instance#machine_type"
}
variable "user_data" {
  description = "VM description."
  default = "Managed by terraform plan https://github.com/Eimert/terraform-google-compute-engine-instance"
}

variable "disk_type" {
  description = "pd-standard or pd-ssd"
  default = "pd-standard"
}

variable "disk_size" {
  description = "Size in GB"
  default = "20"
}
variable "disk_image" {
  description = "OS image"
}

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
  description = "Allow google cloud to restart VM for patching (recommended)."
  default = "true"
}

variable "dns_managed_zone_name_indicator" {
  description = "Descriptive name for dns_zone_name."
  default = "cloud-zone"
}

variable "dns_zone_name" {
  description = "The DNS zone that is pointing to Google' nameservers (if any). A.k.a. Google' DNS SOA (start of authority). Required suffix: . (dot)."
  default = "cloud.eimertvink.nl."
}

variable "dns_record_name" {
  description = "DNS record type == A. For example: 'ansible-dev' will become ansible-dev.cloud.example.com"
  default = "ansible-dev"
}

variable "username" {
  description = "username of user account to be created"
  default = "google"
}

variable "public_key_path" {
  description = "Only private-key auth is enabled by default. Use `ssh-keygen -t rsa` to generate a public-private keypair."
  default = "~/.ssh/id_rsa.pub"
}

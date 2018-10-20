output zones_available {
  description = "Output gc zones having free space."
  value = "{data.google_compute_zones.available.names}"
}

output "addresses" {
  description = "VM IP addresses."
  value = "${join(",", google_compute_address.instances.*.address)}"
}

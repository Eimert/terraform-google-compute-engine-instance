output zones_available {
  value = "{data.google_compute_zones.available.names}"
}

output "addresses" {
  value = "${join(",", google_compute_address.instances.*.address)}"
}

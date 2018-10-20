
resource "google_compute_address" "instances" {
  count = "${var.amount}"
  name  = "${var.name_prefix}-${count.index}"
  region = "${var.region}"
}

resource "google_compute_disk" "instances" {
  count = "${var.amount}"

  name = "${var.name_prefix}-${count.index+1}"
  type = "${var.disk_type}"
  size = "${var.disk_size}"
  # optional
  zone = "${var.zone}"

  image = "${var.disk_image}"

  provisioner "local-exec" {
    command    = "${var.disk_create_local_exec_command_or_fail}"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    command    = "${var.disk_create_local_exec_command_and_continue}"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    when       = "destroy"
    command    = "${var.disk_destroy_local_exec_command_or_fail}"
    on_failure = "fail"
  }

  provisioner "local-exec" {
    when       = "destroy"
    command    = "${var.disk_destroy_local_exec_command_and_continue}"
    on_failure = "continue"
  }
}

# https://www.terraform.io/docs/providers/google/r/compute_instance.html
resource "google_compute_instance" "instances" {
  count = "${var.amount}"

  name         = "${var.name_prefix}-${count.index+1}"
  zone         = "${var.zone}"
  machine_type = "${var.machine_type}"

  boot_disk = {
    source      = "${google_compute_disk.instances.*.name[count.index]}"
    auto_delete = false
  }

  # reference: https://cloud.google.com/compute/docs/storing-retrieving-metadata
  metadata {
    description  = "Managed by Terraform"
    user-data = "${replace(replace(var.user_data, "$$ZONE", var.zone), "$$REGION", var.region)}"
    ssh-keys = "${var.username}:${file("${var.public_key_path}")}"
  }

  network_interface = {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.instances.*.address[count.index]}"
    }
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "${var.automatic_restart}"
  }

  allow_stopping_for_update = "true"
}

# ========================================================================================= #
#                                  provisioner actions                                      #
# ========================================================================================= #

# resource "null_resource" "provisioner" {
#   triggers {
#     vm                            = "${google_compute_instance.instances.name}"
#   }

#   # generic connection block for all provisioners
#   connection {
#     type                          = "ssh"
#     host                          = "${google_compute_address.instances.*.address[count.index]}"
#     user                          = "${var.username}"
#     private_key                   = "${file("${var.private_key_path}")}"
#   }

# reference: https://github.com/jonmorehouse/terraform-provisioner-ansible
# fails: not maintained, not compatible with latest tf version
# provisioner "ansible" {
#   playbook = "awx.yml"
#   hosts = ["all"]
# }

# }

# ========================================================================================= #
#                   binding a DNS name to the ephemeral IP of a new instance                #
#                            requires google_dns_managed_zone                               #
# ========================================================================================= #

resource "google_dns_record_set" "dns_record" {
  # name = "${google_compute_instance.instances.*.name[count.index]}.${google_dns_managed_zone.dns_zone.dns_name}"
  # for example: dns_record_name=ansible-dev
  # will be: ansible-dev.cloud.eimertvink.nl
  # name = "${var.dns_record_name}.${google_dns_managed_zone.managed_zone.dns_name}"
  # managed_zone = "${google_dns_managed_zone.managed_zone.name}"
  name = "${var.dns_record_name}.${var.dns_zone_name}"
  managed_zone = "${var.dns_managed_zone_name_indicator}"
  type = "A"
  ttl  = 300

  rrdatas = ["${google_compute_instance.instances.*.network_interface.0.access_config.0.assigned_nat_ip}"]
}

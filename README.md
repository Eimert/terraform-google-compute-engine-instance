# terraform-google-compute-engine-instance

 - Separated disk and static ip for better manageability
 - Substitutes `$$REGION` and `$$ZONE` in user-data

## Usage example:

Creates two instances with public IP addresses. Machine type can be changed without destroying the boot disk.

1. Create a new directory for this terraform configuration
2. Create a main.tf, for example:
```
# Spin up three VMs on compute engine

# Configure the Google Cloud provider
provider "google" {
  credentials = "${file("king-of-my-google-cloud-castle.json")}"
  project     = "smashing-dash-1992"
}

# https://cloud.google.com/compute/docs/images
data "google_compute_image" "os_image" {
  project = "centos-cloud"
  family  = "centos-7"
}

module "gci_test" {
  source       = "github.com/Eimert/terraform-google-compute-engine-instance"
  amount       = 1
  region       = "europe-west4"
  zone         = "europe-west4-c"
  name_prefix  = "ansible-dev"
  machine_type = "custom-2-4096"
  disk_type    = "pd-standard" # or pd-ssd
  disk_size    = "20"
  disk_image   = "${data.google_compute_image.os_image.self_link}"
  user_data    = "this is something I did"
  username     = "eimertvink"
  public_key_path = "~/.ssh/id_rsa.pub"

}

module "gci_test2" {
  source       = "github.com/eimert/terraform-google-compute-engine-instance"
  amount       = 1
  region       = "europe-west4"
  zone         = "europe-west4-c"
  name_prefix  = "ansible-tst"
  machine_type = "n1-highcpu-8"
  disk_type    = "pd-standard" # or pd-ssd
  disk_size    = "20"
  disk_image   = "${data.google_compute_image.os_image.self_link}"
  user_data    = "workhorse"
  username     = "eimertvink"
  public_key_path = "~/.ssh/id_rsa.pub"
}


```
3. Add your google cloud credentials in a .json file. [Getting started guide](https://www.terraform.io/docs/providers/google/getting_started.html#adding-credentials)
4. Change/adapt TF variables.
5. Let terraform fire up the VM's:
```
terraform init
terraform apply
```
6. Wait a few minutes.
7. Connect using SSH (private key auth): `ssh username@<ip in output>`


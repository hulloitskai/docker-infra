// DigitalOcean auth token.
variable "do_token" {}

// Configure DigitalOcean access.
provider "digitalocean" {
  token = "${var.do_token}"
}

// Configure DigitalOcean ssh key for Terraform.
resource "digitalocean_ssh_key" "tf" {
  name       = "${var.name}.tf-pubkey"
  public_key = "${data.local_file.tf_pubkey.content}"
}

// resource "digitalocean_tag" "main" {
//   name = "main"
// }

// Configure DigitalOcean droplet.
resource "digitalocean_droplet" "primary" {
  name = "${var.name}"

  // Required configuration settings:
  image  = "coreos-beta"
  size   = "s-1vcpu-1gb"
  region = "nyc1"

  // Optional configuration settings:
  user_data = "${data.ignition_config.primary.rendered}"
  ssh_keys  = ["${digitalocean_ssh_key.tf.fingerprint}"]

  // tags               = ["${digitalocean_tag.main.id}"]
  private_networking = true

  // SSH connection settings:
  connection {
    user        = "admin"
    type        = "ssh"
    private_key = "${data.local_file.tf_pvtkey.content}"
    timeout     = "2m"
  }
}

// Configure floating IP for DigitalOcean.
//
// Note: DigitalOcean's existing floating IPs cannot be reused (yet). Check
// https://github.com/terraform-providers/terraform-provider-digitalocean/issues/8
// for progress.
//
// Because of this, we provision a new DNS record on Cloudflare for each
// new DigitalOcean instance.
resource "digitalocean_floating_ip" "primary" {
  droplet_id = "${digitalocean_droplet.primary.id}"
  region     = "${digitalocean_droplet.primary.region}"
}

output "primary_floating_ip" {
  value = "${digitalocean_floating_ip.primary.ip_address}"
}

output "primary_public_ip" {
  value = "${digitalocean_droplet.primary.ipv4_address}"
}

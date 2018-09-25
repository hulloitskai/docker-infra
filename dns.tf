// Declare variables:
// Cloudflare API authentication
variable "cf_email" {}

variable "cf_token" {}

// Target Cloudflare domain
variable "cf_domain" {}

// Cloudflare DNS configurations
variable "cf_proxied_names" {
  default = []
}

variable "cf_exposed_names" {
  default = []
}

// TTL for exposed Cloudflare names.
variable "cf_exposed_ttl" {
  default = 120
}

// Configure DNS:
// Configure Cloudflare provider.
provider "cloudflare" {
  email = "${var.cf_email}"
  token = "${var.cf_token}"
}

// Create primary proxied record for this platform.
resource "cloudflare_record" "proxied_primary" {
  domain  = "${var.cf_domain}"
  name    = "${var.cf_domain}"
  value   = "${digitalocean_floating_ip.primary.ip_address}"
  type    = "A"
  proxied = true
}

// Create additional proxied records for each name in cf_proxied_names.
resource "cloudflare_record" "proxied" {
  count   = "${length(var.cf_proxied_names)}"
  domain  = "${var.cf_domain}"
  name    = "${element(var.cf_proxied_names, count.index)}"
  value   = "${digitalocean_floating_ip.primary.ip_address}"
  type    = "A"
  proxied = true
}

// Create primary exposed record for this platform.
resource "cloudflare_record" "exposed_primary" {
  domain = "${var.cf_domain}"
  name   = "${var.name}"
  value  = "${digitalocean_floating_ip.primary.ip_address}"
  type   = "A"
  ttl    = "${var.cf_exposed_ttl}"
}

// Create additional exposed records for each name in cf_exposed_names.
resource "cloudflare_record" "exposed" {
  count  = "${length(var.cf_exposed_names)}"
  domain = "${var.cf_domain}"
  name   = "${element(var.cf_exposed_names, count.index)}"
  value  = "${digitalocean_floating_ip.primary.ip_address}"
  type   = "A"
  ttl    = "${var.cf_exposed_ttl}"
}

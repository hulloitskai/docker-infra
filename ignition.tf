// Password hash for user "admin".
// This is generated with the command:
//     mkpasswd --method=SHA-512 --rounds=8192
variable "ignition_admin_passhash_path" {
  default = "auth/admin.passhash"
}

// Make Ignition config.
data "ignition_config" "primary" {
  users = ["${data.ignition_user.admin.id}"]

  files = [
    "${data.ignition_file.admin_home.*.id}",
    "${data.ignition_file.sshd_config.id}",
    "${data.ignition_file.iptables.id}",
  ]

  systemd = ["${data.ignition_systemd_unit.iptables_restore.id}"]
}

// Configure user "admin".
data "ignition_user" "admin" {
  name  = "admin"
  shell = "/bin/bash"
  uid   = 100

  // Groups:
  primary_group = "users"
  groups        = ["sudo", "docker", "systemd-journal"]

  // Authentication:
  password_hash = "${replace(
    file(var.ignition_admin_passhash_path),
    "/\n$/",
    ""
  )}"

  ssh_authorized_keys = [
    "${data.local_file.tf_pubkey.content}",
    "${data.local_file.user_pubkeys.*.content}",
  ]
}

// Configure systemd unit that restores IPTables rules from `files/rules-save`.
data "ignition_systemd_unit" "iptables_restore" {
  name    = "iptables-restore.service"
  enabled = true
}

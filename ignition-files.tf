// Files to put in /home/admin.
variable "ignition_admin_home_files" {
  default = [
    "files/home/.bash_aliases",
    "files/home/.bash_functions",
    "files/home/.bash_imports",
    "files/home/.bashrc",
    "files/home/.vimrc",
  ]
}

// Configure files to place in /home/admin.
data "ignition_file" "admin_home" {
  count = "${length(var.ignition_admin_home_files)}"

  path = "/home/admin/${basename(
    element(var.ignition_admin_home_files, count.index)
  )}"

  filesystem = "root"
  mode       = 420
  uid        = 100
  gid        = 100

  content {
    content = "${file(element(var.ignition_admin_home_files, count.index))}"
  }
}

// SSH daemon configuration file.
variable "ignition_sshd_config_file" {
  default = "files/sshd_config"
}

// Configure sshd to disallow password authentication.
data "ignition_file" "sshd_config" {
  path       = "/etc/ssh/sshd_config"
  filesystem = "root"
  mode       = 384

  content {
    content = "${file(var.ignition_sshd_config_file)}"
  }
}

// IPTables rules file.
variable "ignition_iptables_file" {
  default = "files/rules-save"
}

// Configure IPTables to restrict networking to :443, :80, :22, and internal
// ports.
data "ignition_file" "iptables" {
  path       = "/var/lib/iptables/rules-save"
  filesystem = "root"
  mode       = 420

  content {
    content = "${file(var.ignition_iptables_file)}"
  }
}

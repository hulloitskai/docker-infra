## Declare SSH keys:
variable "tf_pvtkey_path" {
  default = "auth/id_ed25519.terraform"
}

variable "tf_pubkey_path" {
  default = "auth/id_ed25519.terraform.pub"
}

variable "user_pubkeys_path" {
  default = ["auth/id_ed25519.pub"]
}

## Create local_files from SSH keys:
data "local_file" "tf_pvtkey" {
  filename = "${path.module}/${var.tf_pvtkey_path}"
}

data "local_file" "tf_pubkey" {
  filename = "${path.module}/${var.tf_pubkey_path}"
}

data "local_file" "user_pubkeys" {
  count    = "${length(var.user_pubkeys_path)}"
  filename = "${path.module}/${element(var.user_pubkeys_path, count.index)}"
}

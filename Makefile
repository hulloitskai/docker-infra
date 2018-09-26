## Configurable variables:
SSHKEY = ./auth/id_ed25519.terraform

## Terraform commands:
.PHONY: init apply plan plan-destroy exec destroy fmt

TF = terraform
plan_out = terraform.tfplan

init:
	@$(TF) init
apply:
	@$(TF) apply
plan:
	@$(TF) plan -out=$(plan_out)
plan-destroy:
	@$(TF) plan -destroy -out=$(plan_out)
exec:
	@$(TF) apply "terraform.tfplan"
destroy:
	@$(TF) destroy
fmt:
	@$(TF) fmt


## Docker Machine commands:
.PHONY: mch-create
DKMCH = docker-machine

## mch-create creates a generic docker machine on the remote host.
## Variables: ADDR, SSHKEY
NAME   = $(shell ./scripts/tfparse.sh name)
DOMAIN = $(shell ./scripts/tfparse.sh domain)
ADDR = $(NAME).$(DOMAIN)
mch-create:
	@$(DKMCH) create --driver generic \
					 --generic-ip-address="$(ADDR)" \
					 --generic-ssh-key="$(SSHKEY)" \
					 --generic-ssh-user=admin \
					 "$(NAME)"

mch-rm:
	@$(DKMCH) rm $(NAME)

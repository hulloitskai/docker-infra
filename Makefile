## Configurable variables:
SSHKEY = ./auth/id_ed25519.terraform


## Setup / git-secret commands:
.PHONY: setup

## setup will configure Git to use the hooks in .githooks/.
setup:
	@echo "Setting up pre-commit hook..." && \
	 git config core.hooksPath .githooks
hide:
	@echo "Hiding modified secret files..." && \
	 git secret hide -m


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
NAME = "$(shell ./scripts/tfparse.sh name)"
ADDR = "$(NAME).$(shell ./scripts/tfparse.sh domain)"
mch-create:
	@$(DKMCH) create --driver generic \
					 --generic-ip-address="$(ADDR)" \
					 --generic-ssh-key="$(SSHKEY)" \
					 --generic-ssh-user=admin \
					 --swarm --swarm-master \
					 "$(NAME)"
	@./scripts/machine-import.sh $(NAME)
mch-rm:
	@$(DKMCH) rm $(NAME)

## mch-imp imports the Docker Machine configuration files to secrets/machine/.
mch-imp:
	@./scripts/machine-import.sh $(NAME)

## mch-exp export the Docker Machine configuration files from secrets/machine/
## to the host machine (uses $MACHINE_STORAGE_DIR, or $HOME/.docker/machine if
## the former is not set).
mch-exp:
	@./scripts/machine-export.sh $(NAME)

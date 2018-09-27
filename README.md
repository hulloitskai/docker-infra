# docker-infra

_Automated infrastructure for secure Docker hosting infrastructure._

`docker-infra` uses [Terraform](https://www.terraform.io), and
[CoreOS](https://coreos.com) to generate a lightweight, easy-to-use infra
for remotely deploying and managing Docker containers on DigitalOcean.

**Branch `swarm` additional initializes a Docker Swarm manager on the
generated CoreOS instance.**

## Effects

Given a infra named **plat** and a domain named **example.com**,
`docker-infra` is preconfigured to perform the following when `make apply` is
run:

- Create a CoreOS DigitalOcean Droplet named **plat**, which accepts connections
  on ports for SSH, HTTP, HTTPS, Docker Machine networking, and Docker Swarm
  networking; all other connections are rejected.

  It only accepts key-based authentication (no password auth)
  based on the provided SSH keys (more details on this in the _Infrastructure
  Configuration_ section below).

  It also has some shell customizations that can be found in `files/`, which
  can be modified to your liking.

- Create a DigitalOcean Floating IP for above instance.
- Point **example.com** to proxy the above Floating IP (as a "proxied" name,
  this will mask the true origin (i.e. the Floating IP), which will not be
  visible to clients).
- Point **plat.example.com** directly at the above Floating IP (as an "exposed"
  name, this will expose the true origin, and so is a suitable address to use
  with SSH and Docker Machine).

## Prerequisites

The local development machine should have the following tools.

- [Docker](https://www.docker.com) and
  [Docker Machine](https://docs.docker.com/machine/install-machine/) (Docker
  Machine comes preinstalled with _Docker for Mac_ and _Docker for Windows_)
- [Terraform](https://www.terraform.io)
- [`hash512`](https://github.com/steven-xie/hash512) (or some other SHA-512
  password-hashing utility like `mkpasswd`)
- `ssh-keygen` (for making SSH keys; alternatively you can use existing keys)

## Infrastructure Configuration

1. Create an `auth/`directory with the following pieces of data:
   - `admin.passhash`: a password hash generated using
     [`hash512`](https://github.com/steven-xie/hash512). The corresponding
     password will be the password for the primary user, `admin`.
   - `id_ed25519.pub`: a public key for personal access to the server. Should
     be generated along with a corresponding private key using:
     `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "comment"`.
     See [this article](https://medium.com/risan/upgrade-your-ssh-key-to-ed25519-c6e8d60d3c54)
     for a better explanation of the behind-the-scenes of this command.
   - `id_ed25519.terraform`, `id_ed25519.terraform.pub`: the public-private
     key pair that Terraform will use to access the server to perform remote
     provisioning. Generated the same way as `id_ed25519.pub`.
2. Modify `infra.auto.tfvars` to have following shape:

   ```hcl
   // name is the name of your infra, which will be associated with
   // infrastructure names on Cloudflare and DigitalOcean, as well as the
   // name of the resulting Docker Machine. Keep it simple and whitespace-free.
   name = "..."

   // cf_domain is the Cloudflare domain you'd like to attach your infra to,
   // i.e. "stevenxie.me"
   cf_domain = "..."
   ```

3. Create a `terraform.tfvars` of the following shape:

   ```hcl
   // Cloudflare
   cf_email = "..."
   cf_token = "..."

   // DigitalOcean
   do_token = "..."
   ```

   These are secrets that should not be included in your version control system.
   This repository automatically ignores `terraform.tfvars` in the `.gitconfig`.

4. Run `make apply` to automatically generate the infrastructure on DigitalOcean
   and Cloudflare.

## Deploying Docker Containers

`docker-infra` is configured to make container deployment as seamless
as possible.

### Configuration

1. Run `make mch-create` to create a Docker Machine corresponding to
   `grapevine`. You only have to do this step once.
2. Run `. machine.env.sh` to load the environment variables corresponding
   to this Docker Machine into the current shell. _This step has to be run
   every time you want to access the remote Docker daemon._
3. When you are done with deploying to the remote Docker daemon, switch back
   to the local daemon by running `. unmachine.env.sh`.

### Deploying

After sourcing the Docker Machine env variables, deploy a container /
composition of containers / stack / swarm the same way you would on a local
machine. For example, try:

```
docker run -d --name hello-world -p 80:8000 crccheck/hello-world
```

Visit your Droplet's domain or floating IP to see the results.

<br />

## Other Considerations

- Given that your domain is _example.com_, consider manually pointing
  _www.example.com_ at _example.com_ using a CNAME record.
- Consider using this infra as a Docker Swarm manager, using
  `docker swarm init` (while connected to the remote Docker daemon). Once this
  is configured, you can bundle Docker containers into a stack using a
  `docker-compose.yml`, and deploy them together using `docker stack deploy`.
- Consider encrypting `auth/*` and `terraform.tfvars` with
  [`git-secret`](http://git-secret.io).

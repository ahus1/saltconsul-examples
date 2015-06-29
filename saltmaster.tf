# Configure the DigitalOcean Provider

# tag::setupkey[]
# setup connection to digitalocen using the API token
provider "digitalocean" {
    token = "cb93...f552"
}

# Fingerprint of the key, just to have it at hand. Please exchange it with your key
# "c8:df:df:...:d9:41:ce"
# public DigitalOcean SSH key
resource "digitalocean_ssh_key" "default" {
    name = "Terraform Example"
    public_key = "${file("id_rsa.pub")}"
}

# setup one small virtual server in Frankfurt.
# tag::setupsaltstart[]
resource "digitalocean_droplet" "master" {
# end::setupsaltstart[]
    image = "centos-7-0-x64"
    name = "master"
    region = "nyc2"
    size = "512mb"

    # install this SSH key on the machine so we can access it later
    ssh_keys = ["c8:df:df:...:d9:41:ce"]

    # ensure that ssh key is available before we setup this machine
    # as in terraform 0.4.2 there is no automatic dependency here (TODO)
    depends_on = [ "digitalocean_ssh_key.default" ]

# end::setupkey[]

# tag::setupsalt[]
    connection {
      type = "ssh"
      host = "${digitalocean_droplet.master.ipv4_address}"
      port = 22
      timeout = "5m"
      user = "root"
      key_file = "id_rsa"
    }

    provisioner "local-exec" {
        command = "echo bin\ssh root@${digitalocean_droplet.master.ipv4_address} -i id_rsa > master.bat "
    }

    provisioner "local-exec" {
        command = "echo bin\rsync -vr -e 'ssh -i id_rsa' master/srv root@${digitalocean_droplet.master.ipv4_address}:/ > sync.bat "
    }

    # ensure that SSH Keys are copied to the salt master in the next step
    provisioner "local-exec" {
        command = "if not exist master\srv\salt\cloud\conf (mkdir master\srv\salt\cloud\conf)"
    }
    provisioner "local-exec" {
        command = "copy /y id_rsa* master\srv\salt\cloud\conf"
    }

    # copy copntents of master/srv to the server
    provisioner "file" {
        source = "master/srv"
        destination = "/"
    }


    # copy file with additional provisioning commands to the server
    provisioner "file" {
        source = "complete-bootstrap.sh"
        destination = "/tmp/complete-bootstrap.sh"
    }

    # install salt minion and master
    provisioner "remote-exec" {
        inline = [
            # install salt-minion and salt-master, but don't start services
            "curl -L https://bootstrap.saltstack.com | sh -s -- -M -X -A localhost",
            # work around possible missing executable flag
            "cat /tmp/complete-bootstrap.sh | sh -s"
          ]
    }

# end::setupsalt[]

# tag::setupkey[]
}
# end::setupkey[]

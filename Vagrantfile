# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/centos-7.1"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  if Vagrant.has_plugin?("vagrant-vbguest")
    # https://github.com/dotless-de/vagrant-vbguest
    # set auto_update to false, if you do NOT want to check the correct
    # additions version when booting this machine
    config.vbguest.auto_update = false

  # do NOT download the iso file from a webserver
    config.vbguest.no_remote = true
  end

   ## VM COnfigurations


  # Deployment instance salt master
  config.vm.define :master do |master|
    master.vm.network :private_network, ip: "192.168.23.12"
    master.vm.hostname = 'master'

    master.vm.synced_folder "master/srv/", "/srv/"
    master.vm.network :forwarded_port, guest: 22, host: 2201, auto_correct: true

    # salt master ports
    master.vm.network :forwarded_port, guest: 4505, host: 4505
    master.vm.network :forwarded_port, guest: 4506, host: 4506

    # web server
    master.vm.network :forwarded_port, guest: 80, host: 8080

  	# consul ports
    master.vm.network :forwarded_port, guest: 8300, host: 8300, protocol: 'udp'
    master.vm.network :forwarded_port, guest: 8301, host: 8301, protocol: 'udp'
    master.vm.network :forwarded_port, guest: 8302, host: 8302, protocol: 'udp'
    master.vm.network :forwarded_port, guest: 8300, host: 8300, protocol: 'tcp'
    master.vm.network :forwarded_port, guest: 8301, host: 8301, protocol: 'tcp'
    master.vm.network :forwarded_port, guest: 8302, host: 8302, protocol: 'tcp'

    # consul UI - http://localhost:8500/ui
    master.vm.network :forwarded_port, guest: 8500, host: 8500, protocol: 'tcp'

    master.vm.provider "virtualbox" do |v|
      v.name = "master"
    end

    # networking problems with CentOS 7.1
    # https://github.com/mitchellh/vagrant/issues/5590
    master.vm.provision "shell", inline: "nmcli connection reload; systemctl restart network.service"

    master.vm.provision :salt do |config|
      config.install_master = true
      config.verbose = true
	  # show debug output, don't start servers, look for master on localhost
      config.bootstrap_options = "-D -X -A localhost"
      config.temp_config_dir = "/tmp"
    end
	# initial provisioning for problem above.

	$sshkey = <<SSHKEY
	mkdir -p /srv/salt/cloud/conf
	cp /vagrant/id_rsa /srv/salt/cloud/conf
	cp /vagrant/id_rsa.pub /srv/salt/cloud/conf
SSHKEY
    master.vm.provision "shell", inline: $sshkey, run: "always"

    # create keys for the minion installed on the master
    master.vm.provision "shell", path: "complete-bootstrap.sh"
  end

  # Web Elements
  (1..3).each do |i|
    config.vm.define "web#{i}" do |minion|
      minion.vm.network :private_network, ip: "192.168.23.2#{i}"
      minion.vm.hostname = "web#{i}"

      minion.vm.network :forwarded_port, guest: 22, host: 2202, auto_correct: true

      minion.vm.provider "virtualbox" do |v|
        v.name = "web#{i}"
      end

      # networking problems with CentOS 7.1
      # https://github.com/mitchellh/vagrant/issues/5590
      minion.vm.provision "shell", inline: "nmcli connection reload; systemctl restart network.service"
    end
  end

  # Load Balancer Elements
  (1..1).each do |i|
    config.vm.define "lb#{i}" do |minion|
      minion.vm.network :private_network, ip: "192.168.23.3#{i}"
      minion.vm.hostname = "lb#{i}"

      # Loadbalancer
      ## nginx
      minion.vm.network :forwarded_port, guest: 9090, host: 9090, protocol: 'tcp'
      ## fabio routing
      minion.vm.network :forwarded_port, guest: 9999, host: 9999, protocol: 'tcp'
      ## fabio UI
      minion.vm.network :forwarded_port, guest: 9998, host: 9998, protocol: 'tcp'

      minion.vm.network :forwarded_port, guest: 22, host: 2202, auto_correct: true

      minion.vm.provider "virtualbox" do |v|
        v.name = "lb#{i}"
      end
      # networking problems with CentOS 7.1
      # https://github.com/mitchellh/vagrant/issues/5590
      minion.vm.provision "shell", inline: "nmcli connection reload; systemctl restart network.service"
    end
  end

end

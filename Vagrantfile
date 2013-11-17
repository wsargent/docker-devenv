# -*- mode: ruby -*-
# vi: set ft=ruby :

# Use the pre-built vagrant box: http://blog.phusion.nl/2013/11/08/docker-friendly-vagrant-boxes/
BOX_NAME = ENV['BOX_NAME'] || "docker-ubuntu-12.04.3-amd64-vbox"
BOX_URI = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
VF_BOX_URI = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vmwarefusion.box"
AWS_REGION = ENV['AWS_REGION']
AWS_AMI    = ENV['AWS_AMI']
VBOX_VERSION = ENV['VBOX_VERSION'] || "4.3.2"
GIT_REPO = ENV['GIT_REPO'] || "https://github.com/wsargent/docker-devenv"

Vagrant::Config.run do |config|
  # Setup virtual machine box. This VM configuration code is always executed.
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI

  # Shipyard
  # config.vm.forward_port 8005, 8005

  # Set up a bunch of forwarded ports to expose docker containers through the host OS without hassle...
  (49000..49900).each do |port|
    config.vm.network :forwarded_port, :host => port, :guest => port
  end

  # Provision docker and new kernel if deployment was not done.
  # It is assumed Vagrant can successfully launch the provider instance.
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Add lxc-docker package
    pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
      "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
      "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker git python-software-properties; "

    # Add guest additions if local vbox VM. As virtualbox is the default provider,
    # it is assumed it won't be explicitly stated.
    if ENV["VAGRANT_DEFAULT_PROVIDER"].nil? && ARGV.none? { |arg| arg.downcase.start_with?("--provider") }
      pkg_cmd << "echo 'Downloading VBox Guest Additions...'; " \
        "wget -q http://dlc.sun.com.edgesuite.net/virtualbox/{VBOX_VERSION}/VBoxGuestAdditions_{VBOX_VERSION}.iso; "
      # Prepare the VM to add guest additions after reboot
      pkg_cmd << "echo -e 'mount -o loop,ro /home/vagrant/VBoxGuestAdditions_{VBOX_VERSION}.iso /mnt\n" \
        "echo yes | /mnt/VBoxLinuxAdditions.run\numount /mnt\n" \
          "rm /root/guest_additions.sh; ' > /root/guest_additions.sh; " \
        "chmod 700 /root/guest_additions.sh; " \
        "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local; " \
        "echo 'Installation of VBox Guest Additions is proceeding in the background.'; " \
        "echo '\"vagrant reload\" can be used in about 2 minutes to activate the new guest additions.'; "
    end

    # While it's installing, we'll set up the other stuff.

    # Start up a private registry (we can make server point to a common source if needed)
    pkg_cmd << "echo \"127.0.0.1      server\" >> /etc/hosts; \n" 
    pkg_cmd << "docker run -d -p 4444:5000 samalba/docker-registry; "
    
    # Sleep for a bit to give docker some time to get a registry up.
    pkg_cmd << "sleep 5"

    # Pull the images
    pkg_cmd << "cd $HOME; git clone {GIT_REPO} docker-devenv; \n" 

    # Build the base image and push it to the private repository.
    pkg_cmd << "cd $HOME/docker-devenv/images/base; " \
      "docker build -t server:4444/base .; \n" \
      "docker push server:4444/base \n"

    # for i in $(eval echo "<more images go here>"); do
    # cd $HOME/docker-devenv/images/$i
    #   docker build -t=server:4444/$i .
    #   docker push server:4444/$i
    # done;

    # Also pull shipyard and start it on port 8005.
    # pkg_cmd << "docker run -p 8005:8000 shipyard/shipyard; "

    config.vm.provision :shell, :inline => pkg_cmd
  end
end

# Providers were added on Vagrant >= 1.1.0
Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    aws.keypair_name = ENV["AWS_KEYPAIR_NAME"]
    override.ssh.private_key_path = ENV["AWS_SSH_PRIVKEY"]
    override.ssh.username = "ubuntu"
    aws.region = AWS_REGION
    aws.ami    = AWS_AMI
    aws.instance_type = "m1.xlarge"
  end

  config.vm.provider :rackspace do |rs|
    config.ssh.private_key_path = ENV["RS_PRIVATE_KEY"]
    rs.username = ENV["RS_USERNAME"]
    rs.api_key  = ENV["RS_API_KEY"]
    rs.public_key_path = ENV["RS_PUBLIC_KEY"]
    rs.flavor   = /512MB/
    rs.image    = /Ubuntu/
  end

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box = BOX_NAME
    override.vm.box_url = VF_BOX_URI
    #override.vm.synced_folder ".", "/vagrant", disabled: true
    f.vmx["displayName"] = "docker"
  end

  config.vm.provider :virtualbox do |vb|
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    #memory (phusion has 2GB as default)
    #vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end




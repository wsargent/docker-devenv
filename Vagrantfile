# -*- mode: ruby -*-
# vi: set ft=ruby :

# Use the pre-built vagrant box: http://blog.phusion.nl/2013/11/08/docker-friendly-vagrant-boxes/
BOX_NAME = ENV['BOX_NAME'] || "docker-ubuntu-12.04.3-amd64-vbox"
BOX_URI = ENV['BOX_URI'] || "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"
VBOX_VERSION = ENV['VBOX_VERSION'] || "4.3.2"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Setup virtual machine box. This VM configuration code is always executed.
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI

  # Shipyard
  config.vm.network :forwarded_port, :host => 8005, :guest => 8005

  # Redis
  config.vm.network :forwarded_port, :host => 6379, :guest => 6379

  #kafka
  config.vm.network :forwarded_port, :host => 9092, :guest => 9092
  config.vm.network :forwarded_port, :host => 7203, :guest => 7203

  #zookeeper
  config.vm.network :forwarded_port, :host => 2181, :guest => 2181

  # Set up a bunch of forwarded ports to expose docker containers through the host OS without hassle...
  # (49000..49900).each do |port|
  #  config.vm.network :forwarded_port, :host => port, :guest => port
  #end

  # Provision docker and new kernel if deployment was not done.
  # It is assumed Vagrant can successfully launch the provider instance.
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Add lxc-docker package
    pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
      "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
      "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "

    # Add guest additions if local vbox VM. As virtualbox is the default provider,
    # it is assumed it won't be explicitly stated.
    if ENV["VAGRANT_DEFAULT_PROVIDER"].nil? && ARGV.none? { |arg| arg.downcase.start_with?("--provider") }
      pkg_cmd << "echo 'Downloading VBox Guest Additions...'; " \
        "wget -q http://dlc.sun.com.edgesuite.net/virtualbox/#{VBOX_VERSION}/VBoxGuestAdditions_#{VBOX_VERSION}.iso; "
      # Prepare the VM to add guest additions after reboot
      pkg_cmd << "echo -e 'mount -o loop,ro /home/vagrant/VBoxGuestAdditions_#{VBOX_VERSION}.iso /mnt\n" \
        "echo yes | /mnt/VBoxLinuxAdditions.run\numount /mnt\n" \
          "rm /root/guest_additions.sh; ' > /root/guest_additions.sh; " \
        "chmod 700 /root/guest_additions.sh; " \
        "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local; " \
        "echo 'Installation of VBox Guest Additions is proceeding in the background.'; " \
        "echo '\"vagrant reload\" can be used in about 2 minutes to activate the new guest additions.'; "
    end

    # Add vagrant to the docker group, so we don't have to sudo everything.
    pkg_cmd << "gpasswd -a vagrant docker; "

    # Set things up for the internal registry
    pkg_cmd << "echo \"127.0.0.1      internal_registry\" >> /etc/hosts; \n" 
    
    # Need a reboot to load the guest additions.
    pkg_cmd << "shutdown -r +1; "
    config.vm.provision :shell, :inline => pkg_cmd
  end
end

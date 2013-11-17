# Will's Docker Development Environment

This is a one stop Vagrant for a docker based development environment.  It comes with riak-cs, scala, zookeeper, kafka, oracle-java7, playframework, and sbt, and probably a bunch more.  It will pull and set up images for absolutely everything.

## Caution

This is personalized for my use: I recommend you clone your own copy, add this as `upstream` then use `git fetch upstream; git merge upstream/master` if you really want to follow it.  It's not guaranteed to work all the time.

It also depends on a public registry image for the docker registry, so that's possibly a security risk.

## Installation

### Run Vagrant 

```
vagrant up
```

Be prepared to wait while it gets Docker and Shipyard installed.

Reboot to install the Guest Additions:

```
vagrant reload
```

### Run devenv install

Now that you have Guest additions, you should be able to install and run the scripts.

```
./bin/devenv install
```

Once this is done, reboot the VM to have Docker pick up the changes needed for Shipyard:

```
vagrant reload
```

### Configure Shipyard

Once the server has rebooted, you should have shipyard up.  The credentials are "shipyard/admin".

* Go to [http://localhost:8005/hosts/](http://localhost:8005/hosts/) to see Shipyard's hosts.
* In the vagrant VM, `ifconfig eth0` and look for "inet addr:10.0.2.15" -- enter the IP address.
* Check [http://localhost:8005/images/](http://localhost:8005/images/) to verify the new images are there.

## Usage

```
vagrant up
./bin/devenv start
```

## Explanation

It does the following:

* Installs a Vagrant image from Phusion Passenger that is [pre-built with the correct kernel](http://blog.phusion.nl/2013/11/08/docker-friendly-vagrant-boxes/) (so you don't have to update and reboot).
* Installs the VirtualBox Guest Additions (4.3.2, but configurable).
* Downloads and sets up a docker image containing a private repository from the public Docker index (insecure, not ideal).
* Clones this github project from Github inside the Vagrant.
* Runs through a base Docker image that adds important bits to the out of the box Ubuntu 12.04 image.
* Pushes that base docker image to the private Docker repository.

This gives you a base starting point where all your other Dockerfile images can be built starting with:

```
FROM internal_registry:5000/base
```

in your Docker file.

## History

It is based on the Relate-IQ [Vagrantfile](https://github.com/relateiq/docker_public) from the [devenv blog post](http://blog.relateiq.com/a-docker-dev-environment-in-24-hours-part-2-of-2/) .

Additional bits taken from [Mailgun shipper talk](http://www.rackspace.com/blog/how-mailgun-uses-docker-and-contributes-back/).
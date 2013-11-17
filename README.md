# WS-devenv

This is a Vagrantfile for a docker based development environment.

It is based on the Relate-IQ [Vagrantfile](https://github.com/relateiq/docker_public) from the [devenv blog post](http://blog.relateiq.com/a-docker-dev-environment-in-24-hours-part-2-of-2/) .

It does the following:

* Installs a Vagrant image from Phusion Passenger that is [pre-built with the correct kernel](http://blog.phusion.nl/2013/11/08/docker-friendly-vagrant-boxes/) (so you don't have to update and reboot).
* Installs the VirtualBox Guest Additions (4.3.2, but configurable).
* Downloads and sets up a docker image containing a private repository from the public Docker index (insecure, not ideal).
* Clones this github project from Github inside the Vagrant.
* Runs through a base Docker image that adds important bits to the out of the box Ubuntu 12.04 image.
* Pushes that base docker image to the private Docker repository.

This gives you a base starting point where all your other Dockerfile images can be built starting with:

```
from server:4444/base:latest
```

in your Docker file.

Inspiration from [Mailgun shipper talk](http://www.rackspace.com/blog/how-mailgun-uses-docker-and-contributes-back/).
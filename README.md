This is a volume plugin for Docker, allowing Docker containers
to enjoy persistent volumes residing on ploop, either locally
or on the distributed Virtuozzo Storage file system.

## Prerequisites

This plugin relies of the following software:
* [goploop](https://github.com/kolyshkin/goploop) (or [goploop-cli](https://github.com/kolyshkin/goploop-cli))
* [Docker volume plugin helper](https://github.com/docker/go-plugins-helpers/tree/master/volume)

## Docker with Virtuozzo/OpenVZ kernel

**For Docker to work, you need to make sure conntracks are enabled on the host.** In case it's not done, docker might complain like this:

```Error starting daemon: Error initializing network controller: error obtaining controller instance: failed to create NAT chain: iptables failed: iptables --wait -t nat -N DOCKER: iptables v1.4.21: can't initialize iptables table `nat': Table does not exist (do you need to insmod?)\nPerhaps iptables or your kernel needs to be upgraded.\n (exit status 3)```

To fix, edit ```/etc/modprobe.d/parallels.conf``` (or ```/etc/modprobe.d/openvz.conf```) to look like this:

```options nf_conntrack ip_conntrack_disable_ve0=0```

In other words, the value should be set to 0. After making the change, reboot the machine.

## Installation

The following assumes you are using a recent version of Virtuozzo or OpenVZ, and have Docker up and running.

First, you need to have ```ploop-devel``` package installed:

```yum install ploop-devel```

Next, you need to have Go installed, and GOPATH environment variable set:

```
yum install golang git
echo 'export GOPATH=$HOME/go' >> ~/.bash_profile
echo 'PATH=$GOPATH/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
```
 
 Finally, get the plugin:
 
```go get github.com/kolyshkin/docker-volume-ploop```

## Usage

You need to have this plugin started before starting docker daemon.
For available options, see

```docker-volume-ploop -help```

Most important, you need to provide a path where the plugin will store
its volumes. For example:

```docker-volume-ploop -home /some/path```

Next, you need to create a new volume. Example:

```docker volume create -d ploop -o size=512G -name MyFirstVolume```

Finally, run a container with the volume:

```docker run -it -v VOLUME:/MOUNT alpine /bin/ash```

Here ```VOLUME``` is the volume name, and ```MOUNT``` is the path under which
the volume will be available inside a container.

See ```man docker volume``` for other volume operations. For example, to list existing volumes:
 
 ```docker volume ls```
 
## Licensing

This software is licensed under the Apache License, Version 2.0. See
[LICENSE](https://github.com/kolyshkin/docker-volume-ploop/blob/master/LICENSE)
for the full license text.

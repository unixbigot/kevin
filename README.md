# kevin
Control a fleet of embedded or IoT unix systems (eg Raspberry Pi, Orange Pi) using saltstack
(see https://saltstack.com).

SaltStack is a configuration management tool that is similar to 
more well known tools such as Puppet or Ansible.  SaltStack has a free
community-supported version, and a commercial version with extra
features and support.

SaltStack uses a message-bus technology (named ZeroMQ) where the "minion" (client) systems
maintain a connection to the "master" system(s), the master addresses minions
over this message bus, but the minons may also report status information or
alerts to the master(s).

This is very appropriate for IoT environments where devices are firewalled,
behind NAT gateways, or only intermittently connected to the Internet. 

## Goals

If you have a factory or house full of embedded unix systems, this 
project can allow you to:

  * control the configuration on the systems
  * construct and deploy new devices
  * update devices
  * manage and inspect devices (reboot, add or remove software, change settings)
  * monitor performance and operation of your devices

## Requirements

You need a machine to serve as your 'saltstack', this can be a unix server, a
cloud virtual machine, or a Raspberry Pi.

You should designate a "bootstrap server" that can initialise new devices
(this can be the master, but that is tricky if the master is cloud hosted).

Each machine under management must run the SaltStack "minion" process.
SaltStack supports Mac, Linux and Windows.

## FAQ

* Q: Why 'kevin'?
  * A: https://www.youtube.com/watch?v=I3Rw8b90INk

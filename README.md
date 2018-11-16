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

## Usage

### Creating your salt master

```
git clone https://github.com/unixbigot/kevin.git
cd kevin
cp etc/roster.example etc/roster
vi etc/roster # (or use nano) - add your host, say 'alice'
./salt-ssh alice state.apply salt.master
ssh alice git clone https://github.com/unixbigot/kevin.git /srv/salt/base
```

### Installing salt minion on an existing system

```
cd kevin
cp etc/roster.example etc/roster
vi etc/roster # (or use nano) - add your minion host, say 'bob'
# Test that you can connect to bob
./salt-ssh -i bob test.ping
# Now we apply a state to bob
./salt-ssh bob state.apply salt.minion
# Next, on your master system do 'sudo salt-key -a bob'
```

### Making a provisioning station

You are creating a system that will be used to configure new devices
without needing to connect a screen or keyboard to the target system.

For the provisioning station, you will need a computer with at least
one wired interface (say a Raspberry Pi with wired eth0 and wireless
wlan0, or a laptop with wired ethernet).

We will use the provisioning station's wired interface to connect to
the target system, and we will interact with the provisioning station
either via keyboard and screen, or by logging into it via another
network interface.

If you have already made carol a minion, do this on the master:

```
sudo vi /srv/pillar/salt.sls # customise the salt_provision section if neeeded
sudo salt carol grains.append roles provisioning
sudo salt carol state.apply
```

If carol is not a minion, you can use salt-ssh, but salt-ssh does not support persistent grains, so you must apply the roles individually:

```
cd kevin
vi srv/pillar/salt.sls # customise the salt_provision section if neeeded
./salt-ssh -i carol test.ping
for s in master syndic provision ; do ./salt-ssh carol state.apply salt.$s ; done
```

### Using your provisioning server

 1. Connect the target system to the provisioning station using an ethernet cable 
 2. Prepare the target system by booting it from an OS image that has DHCP enabled
 3. On the provisioning station run `cd kevin && ./provision.sh`

This will do the following:

 1. Install salt-minion on the target, with the provisioning station as master
 2. Auto accept the minion's key
 3. Wait for the minion to successfully connect
 4. Set grains.roles to the desired target system roles
 5. Run a "highstate" operation on the target to apply all states that implement the roles
 6. Reset the salt minion's configuration to use the true master instead of the provisioning station

## Development

You can do some testing with docker containers.  

```
  $ docker compose up --build
```

This will give you two containers, a master and minion.  You can get
shell on master with `testrig/master.sh` and minion with
`testrig/minion.sh`.

To wipe and rebuild do this

```
  # kill your running docker by ^C if foreground or...
  $ docker-compose stop
  # then destroy the containers if you want to go back to a clean slate
  $ docker-compose down
```


## FAQ

* Q: Why 'kevin'?
  * A: https://www.youtube.com/watch?v=I3Rw8b90INk


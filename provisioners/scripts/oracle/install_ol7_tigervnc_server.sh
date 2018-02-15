#!/bin/sh -eux
# install tigervnc-server on oracle linux 7.x.
# ==============================================================================
# NOTE: This script file is currently a work-in-progress. DO NOT USE.
# ==============================================================================

# install the vnc server. ------------------------------------------------------
yum -y install tigervnc-server

----------------------------------------------------------------------------------------------------
/etc/sysconfig/vncservers
----------------------------------------------------------------------------------------------------
# THIS FILE HAS BEEN REPLACED BY /lib/systemd/system/vncserver@.service
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
/lib/systemd/system/vncserver@.service
----------------------------------------------------------------------------------------------------
# The vncserver service unit file
#
# Quick HowTo:
# 1. Copy this file to /etc/systemd/system/vncserver@.service
# 2. Edit <USER> and vncserver parameters appropriately
#   ("runuser -l <USER> -c /usr/bin/vncserver %i -arg1 -arg2")
# 3. Run `systemctl daemon-reload`
# 4. Run `systemctl enable vncserver@:<display>.service`
#
# DO NOT RUN THIS SERVICE if your local area network is
# untrusted!  For a secure way of using VNC, you should
# limit connections to the local host and then tunnel from
# the machine you want to view VNC on (host A) to the machine
# whose VNC output you want to view (host B)
#
# [user@hostA ~]$ ssh -v -C -L 590N:localhost:590M hostB
#
# this will open a connection on port 590N of your hostA to hostB's port 590M
# (in fact, it ssh-connects to hostB and then connects to localhost (on hostB).
# See the ssh man page for details on port forwarding)
#
# You can then point a VNC client on hostA at vncdisplay N of localhost and with
# the help of ssh, you end up seeing what hostB makes available on port 590M
#
# Use "-nolisten tcp" to prevent X connections to your VNC server via TCP.
#
# Use "-localhost" to prevent remote VNC clients connecting except when
# doing so through a secure tunnel.  See the "-via" option in the
# `man vncviewer' manual page.


[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
# Clean any existing files in /tmp/.X11-unix environment
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/sbin/runuser -l <USER> -c "/usr/bin/vncserver %i"
PIDFile=/home/<USER>/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'

[Install]
WantedBy=multi-user.target
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
/etc/systemd/system/vncserver-vagrant@:1.service
----------------------------------------------------------------------------------------------------
# Hardware-specific screen resolution settings for user 'vagrant'.
# Display 1: default (1280x1024)
#
# 1. Run `systemctl daemon-reload`
# 2. Run `systemctl enable vncserver-vagrant@:1.service`
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
# Clean any existing files in /tmp/.X11-unix environment
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/sbin/runuser -l vagrant -c "/usr/bin/vncserver %i -geometry 1280x1024"
PIDFile=/home/vagrant/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'

[Install]
WantedBy=multi-user.target
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
/etc/systemd/system/vncserver-vagrant@:2.service
----------------------------------------------------------------------------------------------------
# Hardware-specific screen resolution settings for user 'vagrant'.
# Display 2: Dell Precision M4800 Laptop (1904x972)
#
# 1. Run `systemctl daemon-reload`
# 2. Run `systemctl enable vncserver-vagrant@:2.service`
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
# Clean any existing files in /tmp/.X11-unix environment
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/sbin/runuser -l vagrant -c "/usr/bin/vncserver %i -geometry 1904x972"
PIDFile=/home/vagrant/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'

[Install]
WantedBy=multi-user.target
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
/etc/systemd/system/vncserver-vagrant@:3.service
----------------------------------------------------------------------------------------------------
# Hardware-specific screen resolution settings for user 'vagrant'.
# Display 3: Apple Macbook Pro 15" w/ Retina Display (1428x972)
#
# 1. Run `systemctl daemon-reload`
# 2. Run `systemctl enable vncserver-vagrant@:3.service`
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
# Clean any existing files in /tmp/.X11-unix environment
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/sbin/runuser -l vagrant -c "/usr/bin/vncserver %i -geometry 1428x972"
PIDFile=/home/vagrant/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'

[Install]
WantedBy=multi-user.target
----------------------------------------------------------------------------------------------------

2. Edit the 'vncservers' config file.

   # cd /etc/sysconfig
   # vi vncservers

   VNCSERVERS="2:root 3:oracle"
   VNCSERVERARGS[2]="-geometry 1280x1024 -nolisten tcp -localhost"
   VNCSERVERARGS[3]="-geometry 1280x1024"
   Set the VNC password for any users defined in the "/etc/sysconfig/vncservers" file.

   # Ed Barberis-specific screen resolution settings.
   # 1: default
   # 2: Dell Precision M4800 Laptop
   # 3: Apple Macbook Pro 15" w/ Retina Display
   VNCSERVERS="1:oracle 2:oracle 3:oracle"
   VNCSERVERARGS[1]="-geometry 1280x1024"
   VNCSERVERARGS[2]="-geometry 1904x972"
   VNCSERVERARGS[3]="-geometry 1428x784"

3. Set VNC passwords for all users specified.



runuser -l vagrant -c "mkdir -p /home/vagrant/.vnc"
runuser -l vagrant -c "vncpasswd -f <<< 'vagrant' > /home/vagrant/.vnc/passwd"
runuser -l vagrant -c "chmod 600 /home/vagrant/.vnc/passwd"

#runuser -l vagrant -c "mkdir -p /home/vagrant/.vnc; vncpasswd -f <<< 'vagrant' > /home/vagrant/.vnc/passwd; chmod 600 /home/vagrant/.vnc/passwd"

#mkdir -p /home/vagrant/.vnc
#vncpasswd -f <<< "vagrant" > /home/vagrant/.vnc/passwd
#cd /home/vagrant/.vnc
#chmod 755 .
#chmod 600 passwd 
#chown -R vagrant:vagrant .

#sudo su - vagrant
#vncpasswd -f <<< "vagrant" > $HOME/.vnc/passwd

4. Enable the "vncserver" service for autostart and start the service.

   # chkconfig --list | grep vncserver
   # chkconfig vncserver on

   # service vncserver start
   # service vncserver status

   You should now be able to use a VNC client viewer to connect to the 
   system using the display numbers and passwords defined.

   Use the following commands to stop the service and disable autostart.

   # service vncserver stop
   # service vncserver status

   # chkconfig vncserver off
   # chkconfig --list | grep vncserver

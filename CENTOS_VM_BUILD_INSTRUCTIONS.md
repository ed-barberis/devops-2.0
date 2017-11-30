# CentOS 7 VM Build Instructions

Follow these instructions to build the CentOS Linux 7.4 VM images.

## Build the Vagrant Box Images

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the CentOS Linux 7.4 'base-desktop' box (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/packer/centos
    $ packer build base-desktop-centos74-x86_64.json
    ```
    NOTE: This will take several minutes to run.

3.	Build the CentOS Linux 7.4 'base-headless' box (headless):
    ```
    $ packer build base-headless-centos74-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because the ISO image for CentOS Linux 7.4 has been cached.

4.	Build the CentOS Linux 7.4 'dev' box (desktop):
    ```
    $ packer build dev-centos74-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because it is based on the 'base-desktop-centos74' image.

5.	Build the CentOS Linux 7.4 'ops' box (headless):
    ```
    $ packer build ops-centos74-x86_64.json
    ```
    NOTE: This build is based on the 'base-headless-centos74' image.

6.	Build the CentOS Linux 7.4 'cicd' box (headless):
    ```
    $ packer build cicd-centos74-x86_64.json
    ```
    NOTE: This build is based on the 'ops-centos74' image.

7.	Build the CentOS Linux 7.4 'apm' box (headless):

    NOTE: Prior to building the __APM VM__ image, you will need to perform the following tasks:

	-	Modify the AppDynamics Enterprise Console install script template:
		-	Copy and rename 'provisioners/scripts/centos/install_centos7_appdynamics_enterprise_console.sh.template' to '.sh'.
		-	Edit and replace  account username, password, platform release, server passwords, and other variables with your custom values.
	-	Apply your AppDynamics Controller license file:
		-	Copy your AppDynamics Controller 'license.lic' and rename it to 'provisioners/scripts/centos/tools/appd-controller-license.lic'.

    ```
    $ packer build apm-centos74-x86_64.json
    ```
    This build is based on the 'ops-centos74' image.

## Import the Vagrant Box Images

1.	Import the CentOS Linux 7.4 'dev' box image (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/artifacts/centos/dev-centos74
    $ vagrant box add dev-centos74 dev-centos74.virtualbox.box
    ```

2.	Import the CentOS Linux 7.4 'ops' box image (headless):
    ```
    $ cd ../ops-centos74
    $ vagrant box add ops-centos74 ops-centos74.virtualbox.box
    ```

3.	Import the CentOS Linux 7.4 'cicd' box image (headless):
    ```
    $ cd ../cicd-centos74
    $ vagrant box add cicd-centos74 cicd-centos74.virtualbox.box
    ```

4.	Import the CentOS Linux 7.4 'apm' box image (headless):
    ```
    $ cd ../apm-centos74
    $ vagrant box add apm-centos74 apm-centos74.virtualbox.box
    ```

5.	List the Vagrant box images:
    ```
    $ vagrant box list
    apm-centos74 (virtualbox, 0)
    cicd-centos74 (virtualbox, 0)
    dev-centos74 (virtualbox, 0)
    ops-centos74 (virtualbox, 0)
    ...
    ```

## Provision the VirtualBox Images

1.	Provision the __Developer VM__ with CentOS Linux 7.4 (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/dev
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.09.0-ce, build afdb6d4

    dev[vagrant]$ ansible --version
    ansible 2.4.2.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]

    dev[vagrant]$ <run other commands>
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with CentOS Linux 7.4 (desktop) can also be used directly from VirtualBox.

2.	Provision the __Operations VM__ with CentOS Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/ops
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.09.0-ce, build afdb6d4

    ops[vagrant]$ ansible --version
    ansible 2.4.2.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]

    ops[vagrant]$ <run other commands>
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Provision the __CICD VM__ with CentOS Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/cicd
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    cicd[vagrant]$ sudo su -
    cicd[root]# gitlab-ctl status
    run: gitaly: (pid 633) 393s; run: log: (pid 632) 393s
    run: gitlab-monitor: (pid 687) 393s; run: log: (pid 686) 393s
    run: gitlab-workhorse: (pid 661) 393s; run: log: (pid 660) 393s
    run: logrotate: (pid 678) 393s; run: log: (pid 677) 393s
    run: nginx: (pid 675) 393s; run: log: (pid 674) 393s
    run: node-exporter: (pid 685) 393s; run: log: (pid 684) 393s
    run: postgres-exporter: (pid 718) 393s; run: log: (pid 717) 393s
    run: postgresql: (pid 627) 393s; run: log: (pid 626) 393s
    run: prometheus: (pid 705) 393s; run: log: (pid 704) 393s
    run: redis: (pid 621) 393s; run: log: (pid 619) 393s
    run: redis-exporter: (pid 696) 393s; run: log: (pid 690) 393s
    run: sidekiq: (pid 629) 393s; run: log: (pid 628) 393s
    run: unicorn: (pid 620) 393s; run: log: (pid 618) 393s

    cicd[root]# systemctl status jenkins
      jenkins.service - LSB: Jenkins Automation Server
       Loaded: loaded (/etc/rc.d/init.d/jenkins; bad; vendor preset: disabled)
       Active: active (running) since Wed 2017-09-20 12:08:35 EDT; 2h 22min ago
       ...
    Sep 20 12:08:12 cicd systemd[1]: Starting LSB: Jenkins Automation Server...
    Sep 20 12:08:35 cicd jenkins[967]: Starting Jenkins [  OK  ]
    Sep 20 12:08:35 cicd systemd[1]: Started LSB: Jenkins Automation Server.
    cicd[root]# exit

    cicd[vagrant]$ <run other commands>
    cicd[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [GitLab Community Edition](https://about.gitlab.com/) server locally on port '80' [here](http://10.100.198.230) and the [Jenkins](https://jenkins.io/) build server locally on port '9080' [here](http://10.100.198.230:9080).

4.	Provision the __APM VM__ with CentOS Linux 7.4 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/apm
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    apm[vagrant]$ sudo su -
    apm[root]# cd /opt/appdynamics/platform/platform-admin/bin
    apm[root]# ./platform-admin.sh start-platform-admin
    Starting Enterprise Console Database
    ...
    ***** Enterprise Console Database started *****
    Starting Enterprise Console application
    Waiting for the Enterprise Console application to start.........
    ***** Enterprise Console application started on port 9191 *****
    apm[root]# exit

    apm[vagrant]$ <run other commands>

    apm[vagrant]$ sudo su -
    apm[root]# cd /opt/appdynamics/platform/platform-admin/bin
    apm[root]# ./platform-admin/bin/platform-admin.sh stop-platform-admin
    Attempting to stop process with id [6662]...
    .
    ***** Enterprise Console application stopped *****
    ..
    ***** Enterprise Console Database stopped *****
    apm[root]# exit
    apm[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [AppDynamics Enterprise Console](https://www.appdynamics.com/product/) server locally on port '9191' [here](http://10.100.198.241:9191).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Ansible 2.4.2.0
	-	Ansible Container 0.9.2
-	Ant 1.10.1
-	Consul 1.0.1
-	Cloud-Init 0.7.9 [Optional]
-	Docker 17.09.0 CE
	-	Docker Bash Completion
	-	Docker Compose 1.17.1
	-	Docker Compose Bash Completion
-	Git 2.15.1
	-	Git Bash Completion
	-	Git-Flow 1.11.0 (AVH Edition)
	-	Git-Flow Bash Completion
-	Golang 1.9.2
-	Gradle 4.3.1
-	Groovy 2.4.13
-	Java SE JDK 8 Update 152
-	Java SE JDK 9.0.1
-	Maven 3.5.2
-	Packer 1.1.2
-	Python 2.7.5
	-	Pip 9.0.1
-	Python 3.3.2
	-	Pip3 9.0.1
-	Scala-lang 2.12.4
	-	Scala Build Tool (SBT) 1.0.4
-	Terraform 0.11.0
-	Vault 0.9.0

In addition, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 10.2.2 da70bc4
-	Jenkins 2.73.3

In addition, the following application performance management applications are pre-installed in the __APM VM__ (headless):

-	AppDynamics Enterprise Console 4.4.0.5 Build 4220
	-	AppDynamics Controller 4.4.0.5 Build 19090

The following developer tools are pre-installed in the __Developer VM__ (desktop) only:

-	AppDynamics Java Agent 4.4.0.5 Build 19009
-	Atom Editor 1.22.0
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 62.0.3202.94 (64-bit)
-	Firefox 52.5.0 (64-bit)
-	GVim 7.4.160-1
-	Postman 5.3.2
-	Scala IDE for Eclipse 4.7.0 (Eclipse Oxygen 4.7.1)
-	Spring Tool Suite 3.9.1 IDE (Eclipse Oxygen 4.7.1a)
-	Sublime Text 3 Build 3143
-	Visual Studio Code 1.18.1

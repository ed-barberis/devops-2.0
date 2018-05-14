# CentOS 7 VM Build Instructions

Follow these instructions to build the CentOS Linux 7.4 VM images.

## Build the Vagrant Box Images with Packer

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the CentOS Linux 7.4 'base-desktop' box (desktop):

    This will take several minutes to run. If this is the first time you are
    running a build, the ISO image for CentOS Linux 7.4 will be downloaded and
    cached locally.

    ```
    $ cd /<drive>/projects/devops-2.0/builders/packer/centos
    $ packer build base-desktop-centos74-x86_64.json
    ```

3.	Build the CentOS Linux 7.4 'base-headless' box (headless):

    This will take several minutes to run. However, this build will be shorter
    because the ISO image for CentOS Linux 7.4 has been cached locally and the
    headless image contains fewer packages then the desktop image.

    ```
    $ packer build base-headless-centos74-x86_64.json
    ```

4.	Build the CentOS Linux 7.4 'dev' box (desktop):

    This will take several minutes to run. However, this build will be shorter
    because it is based on the 'base-desktop-centos74' image.

    NOTE: By default, the __DEV VM__ build provisions the AppDynamics Java Agent
    which requires external credentials to download the installer. You will need
    to provide your AppDynamics account user name and password as external
    environment variables.

    The build will __fail__ if they are not set.

    ```
    $ export appd_username="name@example.com"
    $ export appd_password="password"
    $ packer build dev-centos74-x86_64.json
    ```

    For additional configuration options, please refer to the documentation in
    '`provisioners/scripts/common/install_appdynamics_java_agent.sh`' and define
    these variables in '`builders/packer/centos/dev-centos74-x86_64.json`'.

    If you don't have an AppDynamics account, you can remove the line containing
    '`../../../provisioners/scripts/common/install_appdynamics_java_agent.sh`'
    from '`builders/packer/centos/dev-centos74-x86_64.json`' to disable provisioning
    of the Java Agent.

5.	Build the CentOS Linux 7.4 'ops' box (headless):

    This build is based on the 'base-headless-centos74' image.

    ```
    $ packer build ops-centos74-x86_64.json
    ```

6.	Build the CentOS Linux 7.4 'cicd' box (headless):

    This build is based on the 'ops-centos74' image.

    ```
    $ packer build cicd-centos74-x86_64.json
    ```

7.	Build the CentOS Linux 7.4 'apm' box (headless):

    This build is based on the 'base-headless-centos74' image.

    Prior to building the __APM VM__ image, you will need to supply a valid
    AppDynamics Controller license file. To apply your license file:

	-	Copy your AppDynamics Controller '`license.lic`' and rename it to '`provisioners/scripts/centos/tools/appd-controller-license.lic`'.

    NOTE: Configuration and customization for provisioning the __APM VM__ image
    is also handled via external environment variables and requires external
    credentials to download the installer. You will need to provide your
    AppDynamics account user name and password.

    The build will __fail__ if they are not set.

    The Enterprise Controller admin user and database passwords may also be
    provided, but are optional. The default passwords are '`welcome1`'.

    ```
    $ export appd_username="name@example.com"
    $ export appd_password="password"
    $ export appd_admin_password="welcome1"     # [optional]
    $ export appd_db_password="welcome1"        # [optional]
    $ export appd_db_root_password="welcome1"   # [optional]
    $ packer build apm-centos74-x86_64.json
    ```

    For additional configuration options, please refer to the documentation in
    '`provisioners/scripts/centos/install_centos7_appdynamics_enterprise_console.sh`' and define
    these variables in '`builders/packer/centos/apm-centos74-x86_64.json`'.

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

## Start the VirtualBox Images

1.	Start the __Developer VM__ with CentOS Linux 7.4 (desktop):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/dev
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 18.03.1-ce, build 9ee9f40

    dev[vagrant]$ ansible --version
    ansible 2.5.2
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]

    dev[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with CentOS Linux 7.4 (desktop) can also be used directly from VirtualBox.

2.	Start the __Operations VM__ with CentOS Linux 7.4 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/ops
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 18.03.1-ce, build 9ee9f40

    ops[vagrant]$ ansible --version
    ansible 2.5.2
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]

    ops[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Start the __CICD VM__ with CentOS Linux 7.4 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/cicd
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
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
    ```
    Gracefully shutdown the VM:
    ```
    cicd[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [GitLab Community Edition](https://about.gitlab.com/) server locally on port '80' [here](http://10.100.198.230) and the [Jenkins](https://jenkins.io/) build server locally on port '9080' [here](http://10.100.198.230:9080).

4.	Start the __APM VM__ with CentOS Linux 7.4 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/centos/demo/apm
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
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
    ```
    Gracefully shutdown the VM:
    ```
    apm[root]# exit
    apm[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [AppDynamics Enterprise Console](https://www.appdynamics.com/product/) server locally on port '9191' [here](http://10.100.198.241:9191).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Ansible 2.5.2
	-	Ansible Container 0.9.2
-	Ant 1.10.3
-	Consul 1.1.0
-	Cloud-Init 0.7.9 [Optional]
-	Docker 18.03.1 CE
	-	Docker Bash Completion
	-	Docker Compose 1.21.2
	-	Docker Compose Bash Completion
-	Git 2.17.0
	-	Git Bash Completion
	-	Git-Flow 1.11.0 (AVH Edition)
	-	Git-Flow Bash Completion
-	Go 1.10.2
-	Gradle 4.7
-	Groovy 2.4.15
-	Java SE JDK 8 Update 172
-	Java SE JDK 10.0.1
-	JMESPath jp 0.1.3 (command-line JSON processor)
-	jq 1.5 (command-line JSON processor)
-	Maven 3.5.3
-	Packer 1.2.3
-	Python 2.7.5
	-	Pip 10.0.1
-	Python 3.3.2
	-	Pip3 10.0.1
-	Scala 2.12.6
	-	Scala Build Tool (SBT) 1.1.5
-	Terraform 0.11.7
-	Vault 0.10.0

In addition, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 10.7.3 2555d6c
-	Jenkins 2.107.3

In addition, the following application performance management applications are pre-installed in the __APM VM__ (headless):

-	AppDynamics Enterprise Console 4.4.3.0 Build 9459
	-	AppDynamics Controller 4.4.3.4 Build 299
	-	AppDynamics Event Service 4.4.3.0 Build 16720

The following developer tools are pre-installed in the __Developer VM__ (desktop) only:

-	AppDynamics Java Agent 4.4.3.0 Build 23079
-	Atom Editor 1.26.1
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 66.0.3359.170 (64-bit)
-	Firefox 52.7.3 (64-bit)
-	GVim 7.4.160-1
-	IntelliJ IDEA 2018.1.3 (Community Edition)
-	Postman 6.0.10
-	Scala IDE for Eclipse 4.7.0 (Eclipse Oxygen.1 [4.7.1])
-	Spring Tool Suite 3.9.4 IDE (Eclipse Oxygen.3a [4.7.3a])
-	Sublime Text 3 Build 3176
-	Visual Studio Code 1.23.1
-	WebStorm 2018.1.3 (JavaScript IDE)

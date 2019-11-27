# Oracle 7 VM Build Instructions

Follow these instructions to build the Oracle Linux 7.7 VM images.

## Build the Vagrant Box Images with Packer

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the Oracle Linux 7.7 'base-desktop' box (desktop):

    This will take several minutes to run. If this is the first time you are
    running a build, the ISO image for Oracle Linux 7.7 will be downloaded and
    cached locally.

    ```
    $ cd /<drive>/projects/devops-2.0/builders/packer/oracle
    $ packer build base-desktop-ol77-x86_64.json
    ```

3.	Build the Oracle Linux 7.7 'base-headless' box (headless):

    This will take several minutes to run. However, this build will be shorter
    because the ISO image for Oracle Linux 7.7 has been cached locally and the
    headless image contains fewer packages then the desktop image.

    ```
    $ packer build base-headless-ol77-x86_64.json
    ```

4.	Build the Oracle Linux 7.7 'dev' box (desktop):

    This will take several minutes to run. However, this build will be shorter
    because it is based on the 'base-desktop-ol77' image.

    NOTE: By default, the __DEV VM__ build provisions the AppDynamics Java Agent
    which requires external credentials to download the installer. You will need
    to provide your AppDynamics account user name and password as external
    environment variables.

    The build will __fail__ if they are not set.

    ```
    $ export appd_username="name@example.com"
    $ export appd_password="password"
    $ packer build dev-ol77-x86_64.json
    ```

    For additional configuration options, please refer to the documentation in
    '`provisioners/scripts/common/install_appdynamics_java_agent.sh`' and define
    these variables in '`builders/packer/oracle/dev-ol77-x86_64.json`'.

    If you don't have an AppDynamics account, you can remove the line containing
    '`../../../provisioners/scripts/common/install_appdynamics_java_agent.sh`'
    from '`builders/packer/oracle/dev-ol77-x86_64.json`' to disable provisioning
    of the Java Agent.

5.	Build the Oracle Linux 7.7 'ops' box (headless):

    This build is based on the 'base-headless-ol77' image.

    ```
    $ packer build ops-ol77-x86_64.json
    ```

6.	Build the Oracle Linux 7.7 'cicd' box (headless):

    This build is based on the 'ops-ol77' image.

    ```
    $ packer build cicd-ol77-x86_64.json
    ```

7.	Build the Oracle Linux 7.7 'apm' box (headless):

    This build is based on the 'base-headless-ol77' image.

    Prior to building the __APM VM__ image, you will need to supply a valid
    AppDynamics Controller license file. To apply your license file:

	-	Copy your AppDynamics Controller '`license.lic`' and rename it to '`provisioners/scripts/centos/tools/appd-controller-license.lic`'.

    NOTE: Configuration and customization for provisioning the __APM VM__ image
    is also handled via external environment variables and requires external
    credentials to download the installer. You will need to provide your
    AppDynamics account user name and password.

    The build will __fail__ if they are not set.

    The Enterprise Console admin user and database passwords may also be
    provided, but are optional. The default passwords are '`welcome1`'.

    ```
    $ export appd_username="name@example.com"
    $ export appd_password="password"
    $ export appd_admin_password="welcome1"     # [optional]
    $ export appd_db_password="welcome1"        # [optional]
    $ export appd_db_root_password="welcome1"   # [optional]
    $ packer build apm-ol77-x86_64.json
    ```

    For additional configuration options, please refer to the documentation in
    '`provisioners/scripts/centos/install_centos7_appdynamics_enterprise_console.sh`' and define
    these variables in '`builders/packer/oracle/apm-ol77-x86_64.json`'.

## Import the Vagrant Box Images

1.	Import the Oracle Linux 7.7 'dev' box image (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/artifacts/oracle/dev-ol77
    $ vagrant box add dev-ol77 dev-ol77.virtualbox.box
    ```

2.	Import the Oracle Linux 7.7 'ops' box image (headless):
    ```
    $ cd ../ops-ol77
    $ vagrant box add ops-ol77 ops-ol77.virtualbox.box
    ```

3.	Import the Oracle Linux 7.7 'cicd' box image (headless):
    ```
    $ cd ../cicd-ol77
    $ vagrant box add cicd-ol77 cicd-ol77.virtualbox.box
    ```

4.	Import the Oracle Linux 7.7 'apm' box image (headless):
    ```
    $ cd ../apm-ol77
    $ vagrant box add apm-ol77 apm-ol77.virtualbox.box
    ```

5.	List the Vagrant box images:
    ```
    $ vagrant box list
    apm-ol77 (virtualbox, 0)
    cicd-ol77 (virtualbox, 0)
    dev-ol77 (virtualbox, 0)
    ops-ol77 (virtualbox, 0)
    ...
    ```

## Start the VirtualBox Images

1.	Start the __Developer VM__ with Oracle Linux 7.7 (desktop):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/dev
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 18.09.8-ol, build 76804b7

    dev[vagrant]$ ansible --version
    ansible 2.9.1
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  7 2019, 08:19:52) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39.0.1)]

    dev[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with Oracle Linux 7.7 (desktop) can also be used directly from VirtualBox.

2.	Start the __Operations VM__ with Oracle Linux 7.7 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/ops
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 18.09.8-ol, build 76804b7

    ops[vagrant]$ ansible --version
    ansible 2.9.1
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Aug  7 2019, 08:19:52) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39.0.1)]

    ops[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Start the __CICD VM__ with Oracle Linux 7.7 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/cicd
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```
    $ vagrant ssh
    cicd[vagrant]$ sudo gitlab-ctl status
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

    cicd[vagrant]$ sudo systemctl status jenkins
      jenkins.service - LSB: Jenkins Automation Server
       Loaded: loaded (/etc/rc.d/init.d/jenkins; bad; vendor preset: disabled)
       Active: active (running) since Wed 2017-09-20 12:08:35 EDT; 2h 22min ago
       ...
    Sep 20 12:08:12 cicd systemd[1]: Starting LSB: Jenkins Automation Server...
    Sep 20 12:08:35 cicd jenkins[967]: Starting Jenkins [  OK  ]
    Sep 20 12:08:35 cicd systemd[1]: Started LSB: Jenkins Automation Server.

    cicd[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```
    cicd[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [GitLab Community Edition](https://about.gitlab.com/) server locally on port '80' [here](http://10.100.198.230) and the [Jenkins](https://jenkins.io/) build server locally on port '9080' [here](http://10.100.198.230:9080).

4.	Start the __APM VM__ with Oracle Linux 7.7 (headless):

    This will take a few minutes to import the Vagrant box and start the VM.

    NOTE: After the VM boots, it will take a few minutes for all of the AppDynamics
    services to start. The Enterprise Console and Events Service start fairly
    quickly, but the Controller may take several minutes (~5 min).

    Check the progress of the Controller service start by running the `journalctl`
    command below to view the systemd log:
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/apm
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```
    $ vagrant ssh
    apm[vagrant]$ sudo journalctl -fu appdynamics-controller
    ...
    May 21 13:29:15 apm platform-admin.sh[4750]: Controller successfully started.
    May 21 13:29:15 apm platform-admin.sh[4750]: Job duration: 4 minutes 16 seconds
    May 21 13:29:16 apm systemd[1]: Started The AppDynamics Controller..
    <CTRL-C>

    apm[vagrant]$ <run other commands>
    apm[vagrant]$ sudo systemctl status appdynamics-enterprise-console
    apm[vagrant]$ sudo systemctl status appdynamics-events-service
    ```
    Gracefully shutdown the VM:
    ```
    apm[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [AppDynamics Enterprise Console](https://www.appdynamics.com/product/) server locally on port '9191' [here](http://10.100.198.231:9191). The [AppDynamics Controller](https://www.appdynamics.com/product/) server can be accessed locally on port '8090' [here](http://10.100.198.231:8090/controller).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Amazon AWS CLI 1.16.292 (command-line interface) [Optional]
-	Ansible 2.9.1
-	Ant 1.10.7
-	Consul 1.6.2
-	Cloud-Init 0.7.9 [Optional]
-	Docker 18.09.8 CE
	-	Docker Bash Completion
	-	Docker Compose 1.24.1
	-	Docker Compose Bash Completion
-	Git 2.24.0
	-	Git Bash Completion
	-	Git-Flow 1.12.3 (AVH Edition)
	-	Git-Flow Bash Completion
-	Go 1.13.4
-	Gradle 6.0.1
-	Groovy 2.5.8
-	Java SE JDK 8 Update 232 (Amazon Corretto 8)
-	Java SE JDK 11.0.5 (Amazon Corretto 11)
-	Java SE JDK 13.0.1 (Oracle)
-	JMESPath jp 0.1.3 (command-line JSON processor)
-	jq 1.6 (command-line JSON processor)
-	Maven 3.6.3
-	Oracle Compute Cloud Service CLI (opc) 17.2.2 [Optional]
-	Oracle PaaS Service Manager CLI (psm) 1.1.16 [Optional]
-	Packer 1.4.5
-	Python 2.7.5
	-	Pip 19.3.1
-	Python 3.6.9
	-	Pip3 19.3.1
-	Scala 2.13.1
	-	Scala Build Tool (SBT) 1.3.4
-	Terraform 0.12.16
-	Vault 1.3.0
-	XMLStarlet 1.6.1 (command-line XML processor)

In addition, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 12.5.0
-	Jenkins 2.190.3

In addition, the following application performance management applications are pre-installed in the __APM VM__ (headless):

-	AppDynamics Enterprise Console 4.5.16.0 Build 21269
	-	AppDynamics Controller 4.5.16.1 Build 2235
	-	AppDynamics Event Service 4.5.2.0 Build 20561
-	MySQL Shell 8.0.18

The following developer tools are pre-installed in the __Developer VM__ (desktop) only:

-	Apache Tomcat 7.0.96
-	Apache Tomcat 8.5.47
-	AppDynamics Java Agent 4.5.16.0 Build 28759
-	AppDynamics Machine Agent 4.5.16.0 Build 2357
	-	AppDynamics AWS EC2 Monitoring Extension 2.0.1 [Optional]
-	Atom Editor 1.41.0
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 78.0.3904.108 (64-bit)
-	Firefox 60.9.0esr (64-bit)
-	GVim 7.4.160-1
-	JetBrains IntelliJ IDEA 2019.2.4 (Community Edition)
-	JetBrains IntelliJ IDEA 2019.2.4 (Ultimate Edition)
-	JetBrains WebStorm 2019.3 (JavaScript IDE)
-	Postman 7.12.0
-	Scala IDE for Eclipse 4.7.0 (Eclipse Oxygen.1 [4.7.1]) [Optional]
-	Spring Tool Suite 4 [4.4.2] IDE (Eclipse 2019-09 [4.13.0])
-	Sublime Text 3 (3.2.2 Build 3211)
-	Visual Studio Code 1.40.2

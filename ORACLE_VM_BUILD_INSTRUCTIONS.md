  # Oracle 7 VM Build Instructions

Follow these instructions to build the Oracle Linux 7.9 VM images.

## Build the Vagrant Box Images with Packer

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the Oracle Linux 7.9 'base-desktop' box (desktop):

    This will take several minutes to run. If this is the first time you are
    running a build, the ISO image for Oracle Linux 7.9 will be downloaded and
    cached locally.

    ```bash
    $ cd /<drive>/projects/devops-2.0/builders/packer/oracle
    $ packer build base-desktop-ol79-x86_64.json
    ```

3.	Build the Oracle Linux 7.9 'base-headless' box (headless):

    This will take several minutes to run. However, this build will be shorter
    because the ISO image for Oracle Linux 7.9 has been cached locally and the
    headless image contains fewer packages then the desktop image.

    ```bash
    $ packer build base-headless-ol79-x86_64.json
    ```

4.	Build the Oracle Linux 7.9 'dev' box (desktop):

    This will take several minutes to run. However, this build will be shorter
    because it is based on the 'base-desktop-ol79' image.

    ```bash
    $ packer build dev-ol79-x86_64.json
    ```

    For additional configuration options, please refer to the documentation in
    '`provisioners/scripts/common/install_appdynamics_java_agent.sh`' and define
    these variables in '`builders/packer/oracle/dev-ol79-x86_64.json`'.

    If you don't have an AppDynamics account, you can remove the line containing
    '`../../../provisioners/scripts/common/install_appdynamics_java_agent.sh`'
    from '`builders/packer/oracle/dev-ol79-x86_64.json`' to disable provisioning
    of the Java Agent.

5.	Build the Oracle Linux 7.9 'ops' box (headless):

    This build is based on the 'base-headless-ol79' image.

    ```bash
    $ packer build ops-ol79-x86_64.json
    ```

6.	Build the Oracle Linux 7.9 'cicd' box (headless):

    This build is based on the 'ops-ol79' image.

    ```bash
    $ packer build cicd-ol79-x86_64.json
    ```

7.	Build the Oracle Linux 7.9 'apm' box (headless):

    This build is based on the 'base-headless-ol79' image.

    Prior to building the __APM VM__ image, you will need to supply a valid
    AppDynamics Controller license file. To apply your license file:

	-	Copy your AppDynamics Controller '`license.lic`' and rename it to '`provisioners/scripts/centos/tools/appd-controller-license.lic`'.

    NOTE: Configuration and customization for provisioning the __APM VM__ image
    is also handled via external environment variables.

    The Enterprise Console admin user and database passwords may also be
    provided, but are optional. The default passwords are '`welcome1`'.

    ```bash
    $ export appd_admin_password="welcome1"     # [optional]
    $ export appd_db_password="welcome1"        # [optional]
    $ export appd_db_root_password="welcome1"   # [optional]
    $ packer build apm-ol79-x86_64.json
    ```

    For additional configuration options, please refer to the documentation in
    '`provisioners/scripts/centos/install_centos7_appdynamics_enterprise_console.sh`' and define
    these variables in '`builders/packer/oracle/apm-ol79-x86_64.json`'.

## Import the Vagrant Box Images

1.	Import the Oracle Linux 7.9 'dev' box image (desktop):
    ```bash
    $ cd /<drive>/projects/devops-2.0/artifacts/oracle/dev-ol79
    $ vagrant box add dev-ol79 dev-ol79.virtualbox.box
    ```

2.	Import the Oracle Linux 7.9 'ops' box image (headless):
    ```bash
    $ cd ../ops-ol79
    $ vagrant box add ops-ol79 ops-ol79.virtualbox.box
    ```

3.	Import the Oracle Linux 7.9 'cicd' box image (headless):
    ```bash
    $ cd ../cicd-ol79
    $ vagrant box add cicd-ol79 cicd-ol79.virtualbox.box
    ```

4.	Import the Oracle Linux 7.9 'apm' box image (headless):
    ```bash
    $ cd ../apm-ol79
    $ vagrant box add apm-ol79 apm-ol79.virtualbox.box
    ```

5.	List the Vagrant box images:
    ```bash
    $ vagrant box list
    apm-ol79 (virtualbox, 0)
    cicd-ol79 (virtualbox, 0)
    dev-ol79 (virtualbox, 0)
    ops-ol79 (virtualbox, 0)
    ...
    ```

## Start the VirtualBox Images

1.	Start the __Developer VM__ with Oracle Linux 7.9 (desktop):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```bash
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/dev
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```bash
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 19.03.11-ol, build 9bb540d

    dev[vagrant]$ ansible --version
    ansible 2.9.27
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Jun 28 2022, 15:30:04) [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]

    dev[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```bash
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with Oracle Linux 7.9 (desktop) can also be used directly from VirtualBox.

2.	Start the __Operations VM__ with Oracle Linux 7.9 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```bash
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/ops
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```bash
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 19.03.11-ol, build 9bb540d

    ops[vagrant]$ ansible --version
    ansible 2.9.27
      config file = /etc/ansible/ansible.cfg
      configured module search path = [u'/home/vagrant/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /usr/bin/ansible
      python version = 2.7.5 (default, Jun 28 2022, 15:30:04) [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]

    ops[vagrant]$ <run other commands>
    ```
    Gracefully shutdown the VM:
    ```bash
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Start the __CICD VM__ with Oracle Linux 7.9 (headless):

    This will take a few minutes to import the Vagrant box and start the VM:
    ```bash
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/cicd
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```bash
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
    ```bash
    cicd[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [GitLab Community Edition](https://about.gitlab.com/) server locally on port '80' [here](http://10.100.198.230) and the [Jenkins](https://jenkins.io/) build server locally on port '9080' [here](http://10.100.198.230:9080).

4.	Start the __APM VM__ with Oracle Linux 7.9 (headless):

    This will take a few minutes to import the Vagrant box and start the VM.

    NOTE: After the VM boots, it will take a few minutes for all of the AppDynamics
    services to start. The Enterprise Console and Events Service start fairly
    quickly, but the Controller may take several minutes (~5 min).

    Check the progress of the Controller service start by running the `journalctl`
    command below to view the systemd log:
    ```bash
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/oracle/demo/apm
    $ vagrant up
    ```
    Connect to the VM via SSH and run some [optional] commands:
    ```bash
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
    ```bash
    apm[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [AppDynamics Enterprise Console](https://www.appdynamics.com/product/) server locally on port '9191' [here](http://10.100.198.231:9191). The [AppDynamics Controller](https://www.appdynamics.com/product/) server can be accessed locally on port '8090' [here](http://10.100.198.231:8090/controller).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Amazon AWS CLI 2.11.13 (command-line interface) [Optional]
-	Ansible 2.9.27
-	Ant 1.10.13
-	Consul 1.15.2
-	Cloud-Init 0.7.9 [Optional]
-	Docker 19.03.11 CE
	-	Docker Bash Completion
	-	Docker Compose 1.29.2
	-	Docker Compose Bash Completion
-	Git 2.40.0
	-	Git Bash Completion
	-	Git-Flow 1.12.4 (AVH Edition)
	-	Git-Flow Bash Completion
-	Go 1.20.3
-	Gradle 8.1
-	Groovy 4.0.11
-	Java SE JDK 8 Update 372 (Amazon Corretto 8)
-	Java SE JDK 11.0.19 (Amazon Corretto 11)
-	Java SE JDK 17.0.7 (Amazon Corretto 17)
-	Java SE JDK 20.0.1 (Amazon Corretto 20)
-	JMESPath jp 0.2.1 (command-line JSON processor)
-	jq 1.6 (command-line JSON processor)
-	Maven 3.9.1
-	MySQL Community Server 5.7.42
-	Oracle Compute Cloud Service CLI (opc) 17.2.2 [Optional]
-	Oracle PaaS Service Manager CLI (psm) 1.1.16 [Optional]
-	Packer 1.8.6
-	Python 2.7.5
	-	Pip 21.3.1
-	Python 3.6.8
	-	Pip3 21.3.1
-	Scala 3.2.2
-	Scala 2.12.17
	-	Scala Build Tool (SBT) 1.8.2
-	Terraform 1.4.5
-	Vault 1.13.0
-	VIM - Vi IMproved 9.0
-	XMLStarlet 1.6.1 (command-line XML processor)
-	yq 4.33.3 (command-line YAML processor)

In addition, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 15.10.3
-	Jenkins 2.387.2 LTS

In addition, the following application performance management applications are pre-installed in the __APM VM__ (headless):

-	AppDynamics Enterprise Console 23.1.2 Build 22
	-	AppDynamics Controller 23.1.2 Build 53
	-	AppDynamics Events Service 4.5.2 Build 20827
-	MySQL Shell 8.0.33

The following developer tools are pre-installed in the __Developer VM__ (desktop) only:

-	Apache Tomcat 8.5.87
-	Apache Tomcat 9.0.74
-	Apache Tomcat 10.0.27
-	Apache Tomcat 10.1.7
-	AppDynamics Java Agent 23.3.0 Build 34728
-	AppDynamics Machine Agent 23.3.0 Build 3577
	-	AppDynamics AWS EC2 Monitoring Extension 2.1.5 [Optional]
-	Atom Editor 1.57.0
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 112.0.5615.137 (64-bit)
-	Firefox 102.8.0esr (64-bit)
-	JetBrains IntelliJ IDEA 2023.1 (Community Edition)
-	JetBrains IntelliJ IDEA 2023.1 (Ultimate Edition)
-	JetBrains WebStorm 2023.1 (JavaScript IDE)
-	Postman 10.13.3
-	Spring Tool Suite 4 [4.18.0] IDE (Eclipse 2023-03 [4.27.0])
-	Sublime Text 4 (Build 4143)
-	Visual Studio Code 1.77.3

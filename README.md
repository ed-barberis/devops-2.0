# devops-2.0

DevOps 2.0 repository for building and testing containerized microservices.

## Overview

The DevOps 2.0 project enables the user to build two types of [VirtualBox](https://www.virtualbox.org/) VMs. A console (headless) VM designed for an Operations role, and a full desktop VM designed for a Developer role.

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host machine:

-	VirtualBox 5.1.22
    -   VirtualBox Extension Pack 5.1.22
-	Vagrant 1.9.5 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 1.1.8
	-	vagrant-vbguest 0.14.2
-	Packer 1.0.0
-	Git 2.13.0 for Win64
	-	wget 1.9.1
	-	tree 1.5.2.2

## Installation Instructions - Windows 64-Bit

1.	Install [VirtualBox 5.1.22 for Windows 64-bit](http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1.22-115126-Win.exe).

2.	Install [VirtualBox Extension Pack 5.1.22](http://download.virtualbox.org/virtualbox/5.1.22/Oracle_VM_VirtualBox_Extension_Pack-5.1.22-115126.vbox-extpack).

3.	Install [Vagrant 1.9.5 for Windows 64-bit](https://releases.hashicorp.com/vagrant/1.9.5/vagrant_1.9.5.msi).  
    Suggested install folder:  
    `C:\HashiCorp\Vagrant`

4.	Install [Packer 1.0.0 for Windows 64-bit](https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_windows_amd64.zip).  
    Create suggested install folder and extract contents of ZIP file to:  
    `C:\HashiCorp\Packer\bin`

5.	Install [Git 2.13.0 for Windows 64-bit](https://github.com/git-for-windows/git/releases/download/v2.13.0.windows.1/Git-2.13.0-64-bit.exe).

6.	Install optional add-ons for Git Bash.  
    Install [wget 1.9.1 for Windows](https://sourceforge.net/projects/mingw/files/Other/mingwPORT/Current%20Releases/wget-1.9.1-mingwPORT.tar.bz2/download).  
    Extract `wget-1.9.1\mingwPORT\wget.exe` to:  
    `C:\Program Files\Git\mingw64\bin`

    Install [tree 1.5.2.2 for Windows](https://sourceforge.net/projects/gnuwin32/files/tree/1.5.2.2/tree-1.5.2.2-bin.zip/download).  
    Extract `bin\tree.exe` to:  
    `C:\Program Files\Git\mingw64\bin`

## Configuration and Validation

1.	Set Windows Environment `PATH` to:

    ```
    PATH=C:\HashiCorp\Vagrant\bin;C:\HashiCorp\Packer\bin;C:\Program Files\Oracle\VirtualBox;%PATH%
    ```

2.	Launch VirtualBox and configure preferences:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

    For example:  
    File -- > Preferences  
    Default Machine Folder: `<drive>:\vbox`

3.	Reboot Windows.

4.	Launch Git Bash.  
	Start Menu -- > All apps -- > Git -- > Git Bash

5.	Validate installed command-line tools:

    ```
    $ git --version
    git version 2.13.0.windows.1

    $ vagrant --version
    Vagrant 1.9.5

    $ packer --version
    1.0.0
    ```

6.	Install or update the following Vagrant Plugins:

    ```
    $ vagrant plugin install vagrant-cachier -or-
    $ vagrant plugin update vagrant-cachier

    $ vagrant plugin install vagrant-share -or-
    $ vagrant plugin update vagrant-share

    $ vagrant plugin install vagrant-vbguest -or-
    $ vagrant plugin update vagrant-vbguest
    ```

7.	Validate Vagrant plugins:

    ```
    $ vagrant plugin list
    vagrant-cachier (1.2.1)
    vagrant-share (1.1.7, system)
    vagrant-vbguest (0.14.1)
    ```

8.	Validate optional add-ons for Git Bash:

    ```
    $ wget --version
    $ tree --version
    ```

9.	Configure Git for local user:

    ```
    $ git config --global user.name "<your_name>"
    $ git config --global user.email "<your_email>"
    $ git config --global --list
    ```

## Get the Code

1.	Create a folder for your DevOps 2.0 project:

    ```
    $ mkdir -p /<drive>/projects
    $ cd /<drive>/projects
    ```

2.	Get the code from GitHub:

    ```
    $ git clone https://github.com/ed-barberis/devops-2.0.git devops-2.0
    $ cd devops-2.0
    ```

3.	Fix bug in Vagrant VB-Guest Plugin File '`oracle.rb`':

    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.2.5/gems/vagrant-vbguest-0.14.1/lib/vagrant-vbguest/installers
    $ cp -p oracle.rb oracle.rb.orig
    $ cp /<drive>/projects/devops-2.0/shared/patches/vagrant-vbguest/oracle.rb .
    ```

4.	Fix bug in Vagrant VB-Guest Plugin File '`download.rb`':
    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.2.5/gems/vagrant-vbguest-0.14.1/lib/vagrant-vbguest
    $ cp -p download.rb download.rb.orig
    $ cp /<drive>/projects/devops-2.0/shared/patches/vagrant-vbguest/download.rb .
    ```

## Build and Import the Vagrant Box Images

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the Oracle Linux 7.3 'ops' box (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/shared/packer
    $ packer build -only=virtualbox-iso generic-ops-ol73-x86_64.json
    ```
    (NOTE: This will take several minutes to run.)

3.	Build the Oracle Linux 7.3 'dev' box (desktop):
    ```
    $ packer build -only=virtualbox-iso generic-dev-ol73-x86_64.json
    ```
    (NOTE: This will take several minutes to run.  However, this build will be shorter, because the ISO image for Oracle Linux 7.3 has been cached.)

4.	Import the Oracle Linux 7.3 'ops' box image (headless):
    ```
    $ cd builds
    $ vagrant box add generic-ops-ol73 generic-ops-ol73.virtualbox.box
    ```

5.	Import the Oracle Linux 7.3 'dev' box image (desktop):
    ```
    $ vagrant box add generic-dev-ol73 generic-dev-ol73.virtualbox.box
    ```

6.	List the Vagrant box images:
    ```
    $ vagrant box list
    generic-dev-ol73 (virtualbox, 0)
    generic-ops-ol73 (virtualbox, 0)
    ...
    ```

## Provision the VirtualBox Images

1.	Provision the __Operations VM__ with Oracle Linux 7.3 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/projects/generic/vms/ops
    $ vagrant up
    ```
    (NOTE: This will take a few minutes to run the provisioning scripts.)
    ```
    $ vagrant ssh
    generic-ops[vagrant]$ ansible -version
    ansible 2.2.2.0
        config file = /etc/ansible/ansible.cfg
        configured module search path = Default w/o overrides
    generic-ops[vagrant]$ docker -version
    Docker version 1.12.6, build 1512168
    generic-ops[vagrant]$ <run other commands>
    generic-ops[vagrant]$ exit
    $ vagrant halt
    ```

2.	Provision the __Developer VM__ with Oracle Linux 7.3 (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/projects/generic/vms/dev
    $ vagrant up
    ```
    (NOTE: This will take a few more minutes to run the provisioning scripts. The desktop image has added dev tools.)
    ```
    $ vagrant ssh
    generic-dev[vagrant]$ ansible -version
    ansible 2.2.2.0
        config file = /etc/ansible/ansible.cfg
        configured module search path = Default w/o overrides
    generic-dev[vagrant]$ docker -version
    Docker version 1.12.6, build 1512168
    generic-dev[vagrant]$ <run other commands>
    generic-dev[vagrant]$ exit
    $ vagrant halt
    ```

The Developer VM with Oracle Linux 7.3 (desktop) can also be used directly from VirtualBox.

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in both the __Operations VM__ (Oracle Linux 7.3 console) and the __Developer VM__ (Oracle Linux 7.3 desktop):

-	Ansible 2.3.0.0
    -	Ansible Container 0.9.0.0
-	Ant 1.10.1
-   Consul 0.8.3
-   Cloud-init 0.7.5
-	Docker 1.12.6
    -	Docker Bash Completion
    -	Docker Compose 1.13.0
    -	Docker Compose Completion
-	Git 2.13.0
    -	Git Bash Completion
    -	Git-Flow 0.4.2-pre
-   Go 1.8.1
-	Gradle 3.5
-	Java JDK 8 Update 131
-	Maven 3.5.0
-   Packer 1.0.0
-	Python 2.7.5
    -	Pip 9.0.1
-	Python 3.3.2
    -	Pip3 9.0.1
-   Terraform 0.9.5
-   Vault 0.7.2

In addition to the above, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (Oracle Linux 7.3 console):

-	GitLab Community Edition 9.1.4 fed799a
-	Jenkins 2.46.2

The following GUI tools are pre-installed in the __Developer VM__ (Oracle Linux 7.3 desktop) only:

-	Atom Editor 1.17.0
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 58.0.3029.110 (64-bit)
-	Firefox 52.1.0 (64-bit)
-	GVim 7.4.160-1
-	Postman 4.10.7
-	Spring Tool Suite 3.8.4 IDE (Eclipse Neon 4.6.3)
-	Sublime Text 3 Build 3126
-	Visual Studio Code 1.12.2

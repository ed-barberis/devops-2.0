# devops-2.0

DevOps 2.0 repository for building and testing containerized microservices.

## Overview

The DevOps 2.0 project enables an IT Administrator, Software Developer, or DevOps engineer to automate the building of [VirtualBox](https://www.virtualbox.org/) VMs using open source tools from [Hashicorp](https://www.hashicorp.com/).

The first step involves building the base VMs, which consist of two types:

-	__Base-Desktop VM__: A full desktop VM with no project-specific tooling.
-	__Base-Headless VM__: A console (headless) VM with minimal tooling.

Next, using these base VMs as a foundation, the user can build more advanced VM images provisioned for project-specific tasks. These include:

-	__Developer VM__: Desktop VM designed for a project-specific Developer role,
-	__Operations VM__: Headless VM designed for a project-specific Operations role.
-	__CICD VM__: Headless VM designed for continuous integration, continuous delivery (CI/CD) and project-specific DevOps automation.

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host machine:

-	VirtualBox 5.1.26
    -   VirtualBox Extension Pack 5.1.26
-	Vagrant 1.9.8 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 1.1.9
	-	vagrant-vbguest 0.14.2
-	Packer 1.0.4
-	Git 2.14.1 for Win64
	-	wget 1.9.1
	-	tree 1.5.2.2

## Installation Instructions - Windows 64-Bit

1.	Install [VirtualBox 5.1.26 for Windows 64-bit](http://download.virtualbox.org/virtualbox/5.1.26/VirtualBox-5.1.26-117224-Win.exe).

2.	Install [VirtualBox Extension Pack 5.1.26](http://download.virtualbox.org/virtualbox/5.1.26/Oracle_VM_VirtualBox_Extension_Pack-5.1.26-117224.vbox-extpack).

3.	Install [Vagrant 1.9.8 for Windows 64-bit](https://releases.hashicorp.com/vagrant/1.9.8/vagrant_1.9.8_x86_64.msi).  
    auggested install folder:  
    `C:\HashiCorp\aagrant`

4.	Install [Packer 1.0.4 for Windows 64-bit](https://releases.hashicorp.com/packer/1.0.4/packer_1.0.4_windows_amd64.zip).  
    Create suggested install folder and extract contents of ZIP file to:  
    `C:\HashiCorp\Packer\bin`

5.	Install [Git 2.14.1 for Windows 64-bit](https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-64-bit.exe).

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
    git version 2.14.1.windows.1

    $ vagrant --version
    Vagrant 1.9.8

    $ packer --version
    1.0.4
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
    vagrant-share (1.1.8, system)
    vagrant-vbguest (0.14.2)
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
    $ git submodule update --init --recursive
    ```

3.	Fix bug in Vagrant VB-Guest Plugin File '`oracle.rb`':

    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.3.4/gems/vagrant-vbguest-0.14.2/lib/vagrant-vbguest/installers
    $ cp -p oracle.rb oracle.rb.orig
    $ cp /<drive>/projects/devops-2.0/shared/patches/vagrant-vbguest/oracle.rb .
    ```

4.	Fix bug in Vagrant VB-Guest Plugin File '`download.rb`':
    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.3.4/gems/vagrant-vbguest-0.14.2/lib/vagrant-vbguest
    $ cp -p download.rb download.rb.orig
    $ cp /<drive>/projects/devops-2.0/shared/patches/vagrant-vbguest/download.rb .
    ```

## Build the Vagrant Box Images

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the Oracle Linux 7.3 'base-desktop' box (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/packer
    $ packer build base-desktop-ol73-x86_64.json
    ```
    NOTE: This will take several minutes to run.

3.	Build the Oracle Linux 7.3 'base-headless' box (headless):
    ```
    $ packer build base-headless-ol73-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because the ISO image for Oracle Linux 7.3 has been cached.

4.	Build the Oracle Linux 7.3 'dev' box (desktop):
    ```
    $ packer build dev-ol73-x86_64.json
    ```
    NOTE: This will take several minutes to run.  However, this build will be shorter because it is based on the 'base-desktop-ol73' image.

5.	Build the Oracle Linux 7.3 'ops' box (headless):
    ```
    $ packer build ops-ol73-x86_64.json
    ```
    NOTE: This build is based on the 'base-headless-ol73' image.

6.	Build the Oracle Linux 7.3 'cicd' box (headless):
    ```
    $ packer build cicd-ol73-x86_64.json
    ```
    NOTE: This build is based on the 'ops-ol73' image.

## Import the Vagrant Box Images

1.	Import the Oracle Linux 7.3 'dev' box image (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/artifacts/dev-ol73
    $ vagrant box add dev-ol73 dev-ol73.virtualbox.box
    ```

2.	Import the Oracle Linux 7.3 'ops' box image (headless):
    ```
    $ cd ../ops-ol73
    $ vagrant box add ops-ol73 ops-ol73.virtualbox.box
    ```

3.	Import the Oracle Linux 7.3 'cicd' box image (headless):
    ```
    $ cd ../cicd-ol73
    $ vagrant box add cicd-ol73 cicd-ol73.virtualbox.box
    ```

4.	List the Vagrant box images:
    ```
    $ vagrant box list
    cicd-ol73 (virtualbox, 0)
    dev-ol73 (virtualbox, 0)
    ops-ol73 (virtualbox, 0)
    ...
    ```

## Provision the VirtualBox Images

1.	Provision the __Developer VM__ with Oracle Linux 7.3 (desktop):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/demo/dev
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    dev[vagrant]$ docker --version
    Docker version 17.03.1-ce, build 276fd32
    dev[vagrant]$ ansible --version
    ansible 2.3.1.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = Default w/o overrides
      python version = 2.7.5 (default, May 29 2017, 20:42:36) [GCC 4.8.5 20150623 (Red Hat 4.8.5-11)]
    dev[vagrant]$ <run other commands>
    dev[vagrant]$ exit
    $ vagrant halt
    ```

    The Developer VM with Oracle Linux 7.3 (desktop) can also be used directly from VirtualBox.

2.	Provision the __Operations VM__ with Oracle Linux 7.3 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/demo/ops
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    ops[vagrant]$ docker --version
    Docker version 17.03.1-ce, build 276fd32
    ops[vagrant]$ ansible --version
    ansible 2.3.1.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = Default w/o overrides
      python version = 2.7.5 (default, May 29 2017, 20:42:36) [GCC 4.8.5 20150623 (Red Hat 4.8.5-11)]
    ops[vagrant]$ <run other commands>
    ops[vagrant]$ exit
    $ vagrant halt
    ```

3.	Provision the __CICD VM__ with Oracle Linux 7.3 (headless):
    ```
    $ cd /<drive>/projects/devops-2.0/builders/vagrant/demo/cicd
    $ vagrant up
    ```
    NOTE: This will take a few minutes to import the Vagrant box.
    ```
    $ vagrant ssh
    cicd[vagrant]$ docker --version
    Docker version 17.03.1-ce, build 276fd32
    cicd[vagrant]$ ansible --version
    ansible 2.3.1.0
      config file = /etc/ansible/ansible.cfg
      configured module search path = Default w/o overrides
      python version = 2.7.5 (default, May 29 2017, 20:42:36) [GCC 4.8.5 20150623 (Red Hat 4.8.5-11)]
    cicd[vagrant]$ <run other commands>
    cicd[vagrant]$ exit
    $ vagrant halt
    ```

    NOTE: You can access the [GitLab Community Edition](https://about.gitlab.com/) server locally on port '80' [here](http://10.100.198.230) and the [Jenkins](https://jenkins.io/) build server locally on port '9080' [here](http://10.100.198.230:9080).

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in the __Developer VM__ (desktop), __Operations VM__ (headless), and the __CICD VM__ (headless):

-	Ansible 2.3.1.0
    -	Ansible Container 0.9.1
-	Ant 1.10.1
-   Consul 0.9.2
-   Cloud-Init 0.7.9 [Optional]
-	Docker 17.03.1-ce
    -	Docker Bash Completion
    -	Docker Compose 1.16.1
    -	Docker Compose Bash Completion
-	Git 2.14.1
    -	Git Bash Completion
    -	Git-Flow 1.11.0 (AVH Edition)
    -	Git-Flow Bash Completion
-   Golang 1.9
-	Gradle 4.1
-	Groovy 2.4.12
-	Java JDK 8 Update 144
-	Maven 3.5.0
-	Oracle Compute Cloud Service CLI (opc) 17.2.2 [Optional]
-	Oracle PaaS Service Manager CLI (psm) 1.1.15 [Optional]
-   Packer 1.0.4
-	Python 2.7.5
    -	Pip 9.0.1
-	Python 3.3.2
    -	Pip3 9.0.1
-   Scala-lang 2.12.3
    -	Scala Build Tool (SBT) 1.0.1
-   Terraform 0.10.3
-   Vault 0.8.2

In addition to the above, the following continuous integration and continuous delivery (CI/CD) applications are pre-installed in the __CICD VM__ (headless):

-	GitLab Community Edition 9.5.3 789cc67
-	Jenkins 2.60.3

The following GUI tools are pre-installed in the __Developer VM__ (desktop) only:

-	Atom Editor 1.19.6
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 60.0.3112.113 (64-bit)
-	Firefox 52.3.0 (64-bit)
-	GVim 7.4.160-1
-	Postman 5.2.0
-	Scala IDE for Eclipse 4.6.1 (Eclipse Neon 4.6.3)
-	Spring Tool Suite 3.9.0 IDE (Eclipse Oxygen 4.7.0)
-	Sublime Text 3 Build 3126
-	Visual Studio Code 1.15.1

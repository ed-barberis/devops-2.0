# devops-2.0

DevOps 2.0 repository for building and testing containerized microservices.

## Overview

The DevOps 2.0 project enables the user to build two types of [VirtualBox](https://www.virtualbox.org/) VMs. A console (headless) VM designed for an IT Administrator role, and a full desktop VM designed for a Developer role.

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host machine:

-	VirtualBox 5.1.14
    -   VirtualBox Extension Pack 5.1.14
-	Vagrant 1.9.1 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 1.1.6
	-	vagrant-vbguest 0.13.0
-	Packer 0.12.2
-	Git 2.11.1 for Win64
	-	wget 1.9.1
	-	tree 1.5.2.2

## Installation Instructions - Windows 64-Bit

1.	Install [VirtualBox 5.1.14 for Windows 64-bit](http://download.virtualbox.org/virtualbox/5.1.14/VirtualBox-5.1.14-112924-Win.exe).

2.	Install [VirtualBox Extension Pack 5.1.14](http://download.virtualbox.org/virtualbox/5.1.14/Oracle_VM_VirtualBox_Extension_Pack-5.1.14-112924.vbox-extpack).

3.	Install [Vagrant 1.9.1 for Windows 64-bit](https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1.msi).  
    Suggested install folder:  
    `C:\HashiCorp\Vagrant`

4.	Install [Packer 0.12.2 for Windows 64-bit](https://releases.hashicorp.com/packer/0.12.2/packer_0.12.2_windows_amd64.zip).  
    Create suggested install folder and extract contents of ZIP file to:  
    `C:\HashiCorp\Packer\bin`

5.	Install [Git 2.11.1 for Windows 64-bit](https://github.com/git-for-windows/git/releases/download/v2.11.1.windows.1/Git-2.11.1-64-bit.exe).

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
    git version 2.11.1.windows.1

    $ vagrant --version
    Vagrant 1.9.1

    $ packer --version
    0.12.2
    ```

6.	Install or update the following Vagrant Plugins:

    ```
    $ vagrant plugin install vagrant-cachier –or–
    $ vagrant plugin update vagrant-cachier

    $ vagrant plugin install vagrant-share –or–
    $ vagrant plugin update vagrant-share

    $ vagrant plugin install vagrant-vbguest –or–
    $ vagrant plugin update vagrant-vbguest
    ```

7.	Validate Vagrant plugins:

    ```
    $ vagrant plugin list
    vagrant-cachier (1.2.1)
    vagrant-share (1.1.6, system)
    vagrant-vbguest (0.13.0)
    ```

8.	Validate optional add-ons for Git Bash:

    ```
    $ wget --version
    $ tree --version
    ```

9.	Configure Git for local user:

    ```
    $ git config --global user.name="<your_name>"
    $ git config --global user.email=”<your_email>”
    $ git config --global –list
    ```

## Get the Code

1.	Create a folder for your DevOps 2.0 project:

    ```
    $ mkdir –p /<drive>/projects
    $ cd /<drive>/projects
    ```

2.	Get the code from GitHub:

    ```
    $ git clone https://github.com/ed-barberis/devops-2.0.git devops-2.0
    ```

3.	Fix bug in Vagrant VB-Guest Plugin File '`oracle.rb`':

    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.2.5/gems/vagrant-vbguest-0.13.0/lib/vagrant-vbguest/installers
    $ cp –p oracle.rb oracle.rb.orig
    $ cp /<drive>/projects/devops-2.0/packer/bento-ol73-desktop/shared/oracle.rb .
    ```

4.	Fix bug in Vagrant VB-Guest Plugin File ‘`download.rb`’:
    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.2.5/gems/vagrant-vbguest-0.13.0/lib/vagrant-vbguest
    $ cp –p download.rb download.rb.orig
    $ cp /<drive>/projects/devops-2.0/packer/bento-ol73-desktop/shared/download.rb .
    ```

## Build and Import the Vagrant Box Images

1.	Start VirtualBox:  
    Start Menu -- > All apps -- > Oracle VM VirtualBox -- > Oracle VM VirtualBox

2.	Build the Oracle Linux 7.3 console box:
    ```
    $ cd /<drive>/projects/devops-2.0/chef/bento
    $ packer build -only=virtualbox-iso oracle-7.3-console-x86_64.json
    ```
    (NOTE: This will take several minutes to run.)

3.	Build the Oracle Linux 7.3 desktop box:
    ```
    $ packer build -only=virtualbox-iso oracle-7.3-desktop-x86_64.json
    ```
    (NOTE: This will take several minutes to run.  However, this build will be shorter, because the ISO image for Oracle Linux 7.3 has been cached.)

4.	Import the Oracle Linux 7.3 console box image:
    ```
    $ cd builds
    $ vagrant box add bento-ol73-console oracle-7.3-console.virtualbox.box
    ```

5.	Import the Oracle Linux 7.3 desktop box image:
    ```
    $ vagrant box add bento-ol73-desktop oracle-7.3-desktop.virtualbox.box
    ```

6.	List the Vagrant box images:
    ```
    $ vagrant box list
    bento-ol73-console (virtualbox, 0)
    bento-ol73-desktop (virtualbox, 0)
    …
    ```

## Provision the VirtualBox Images

1.	Provision the __IT Administrator VM__ with Oracle Linux 7.3 console:
    ```
    $ cd /<drive>/projects/devops-2.0/packer/bento-ol73-console
    $ vagrant up
    ```
    (NOTE: This will take a few minutes to run the provisioning scripts.)
    ```
    $ vagrant ssh
    bento-ol73-console[vagrant]$ ansible –version
    ansible 2.2.1.0
        config file = /etc/ansible/ansible.cfg
        configured module search path = Default w/o overrides
    bento-ol73-console[vagrant]$ docker –version
    Docker version 1.12.6, build 1512168
    bento-ol73-console[vagrant]$ <run other commands>
    bento-ol73-console[vagrant]$ exit
    $ vagrant halt
    ```

2.	Provision the __Developer VM__ with Oracle Linux 7.3 desktop:
    ```
    $ cd /<drive>/projects/devops-2.0/packer/bento-ol73-desktop
    $ vagrant up
    ```
    (NOTE: This will take a few more minutes to run the provisioning scripts. The desktop image has added dev tools.)
    ```
    $ vagrant ssh
    bento-ol73-desktop[vagrant]$ ansible –version
    ansible 2.2.1.0
        config file = /etc/ansible/ansible.cfg
        configured module search path = Default w/o overrides
    bento-ol73-desktop[vagrant]$ docker –version
    Docker version 1.12.6, build 1512168
    bento-ol73-desktop[vagrant]$ <run other commands>
    bento-ol73-desktop[vagrant]$ exit
    $ vagrant halt
    ```

The Developer VM with Oracle Linux 7.3 desktop can also be used directly from VirtualBox.

## DevOps 2.0 Bill-of-Materials

The following command-line tools and utilities are pre-installed in both the __IT Administrator VM__ (Oracle Linux 7.3 console) and the __Developer VM__ (Oracle Linux 7.3 desktop):

-	Ansible 2.2.1.0
    -	Ansible Container 0.3.0-pre
-	Ant 1.10.0
-	Docker 1.12.6
    -	Docker Bash Completion
    -	Docker Compose 1.10.0
    -	Docker Compose Completion
-	Git 2.11.1
    -	Git Bash Completion
    -	Git-Flow 0.4.2-pre
-	Java JDK 8 Update 121
-	Maven 3.3.9
-	Oracle Public Cloud (OPC) CLI 16.3.6.20160912.235155
-	PaaS Service Manager (PSM) CLI 1.1.11
-	Python 2.7.5
    -	Pip 9.0.1
-	Python 3.3.2
    -	Pip3 9.0.1

The following GUI tools are pre-installed in the __Developer VM__ (Oracle Linux 7.3 desktop) only:

-	Atom Editor 1.13.1
-	Brackets Editor 1.7 Experimental 1.7.0-0
-	Chrome 56.0.2924.87 (64-bit)
-	Firefox 45.7.0
-	GVim 7.4.160-1
-	Postman 4.9.3
-	Sublime Text 3 Build 3126

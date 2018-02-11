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
-	__APM VM__: Headless VM designed for Application Performance Monitoring with the AppDynamics Controller.

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host machine:

-	VirtualBox 5.2.6
	-	VirtualBox Extension Pack 5.2.6
-	Vagrant 2.0.2 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 1.1.9
	-	vagrant-vbguest 0.15.1
-	Packer 1.2.0
-	Git 2.16.1 for Win64
	-	wget 1.9.1
	-	tree 1.5.2.2

## Installation Instructions - Windows 64-Bit

1.	Install [VirtualBox 5.2.6 for Windows 64-bit](http://download.virtualbox.org/virtualbox/5.2.6/VirtualBox-5.2.6-120293-Win.exe).

2.	Install [VirtualBox Extension Pack 5.2.6](http://download.virtualbox.org/virtualbox/5.2.6/Oracle_VM_VirtualBox_Extension_Pack-5.2.6-120293.vbox-extpack).

3.	Install [Vagrant 2.0.2 for Windows 64-bit](https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.msi).  
    Suggested install folder:  
    `C:\HashiCorp\vagrant`  

    **NOTE:** There is currently an issue on Windows 10 when using SSH to access the VM with Git Bash or Cygwin. To work-around, set the following environment variable:  
    ```
    export VAGRANT_PREFER_SYSTEM_BIN=1
    ```

    If this is set, Vagrant will prefer using utility executables (like `ssh` and `rsync`) from the local system instead of those vendored within the Vagrant installation.  

4.	Install [Packer 1.2.0 for Windows 64-bit](https://releases.hashicorp.com/packer/1.2.0/packer_1.2.0_windows_amd64.zip).  
    Create suggested install folder and extract contents of ZIP file to:  
    `C:\HashiCorp\Packer\bin`  

5.	Install [Git 2.16.1 for Windows 64-bit](https://github.com/git-for-windows/git/releases/download/v2.16.1.windows.1/Git-2.16.1-64-bit.exe).

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
    $ VBoxManage --version
    5.2.6r120293

    $ vagrant --version
    Vagrant 2.0.2

    $ packer --version
    1.2.0

    $ git --version
    git version 2.16.1.windows.1
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
    vagrant-share (1.1.9, system)
    vagrant-vbguest (0.15.1)
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
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.4.3/gems/vagrant-vbguest-0.15.1/lib/vagrant-vbguest/installers
    $ cp -p oracle.rb oracle.rb.orig
    $ cp /<drive>/projects/devops-2.0/shared/patches/vagrant-vbguest/oracle.rb .
    ```

4.	Fix bug in Vagrant VB-Guest Plugin File '`download.rb`':
    ```
    $ cd /c/Users/<your-username>/.vagrant.d/gems/2.4.3/gems/vagrant-vbguest-0.15.1/lib/vagrant-vbguest
    $ cp -p download.rb download.rb.orig
    $ cp /<drive>/projects/devops-2.0/shared/patches/vagrant-vbguest/download.rb .
    ```

## Build the Vagrant Box Images

The DevOps 2.0 project now supports CentOS and Oracle VM builds. Click on a link below for platform-specific instructions and Bill-of-Materials.

-	[CentOS Linux 7 VMs](CENTOS_VM_BUILD_INSTRUCTIONS.md): Instructions
-	[Oracle Linux 7 VMs](ORACLE_VM_BUILD_INSTRUCTIONS.md): Instructions

## DevOps 2.0 Bill-of-Materials

NOTE: The Bill-of-Materials section has been moved to the platform-specific instructions links above.

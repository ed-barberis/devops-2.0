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
-	__APM VM__: Headless VM designed for Application Performance Monitoring with the AppDynamics App iQ Platform. It consists of the Enterprise Console, Controller, and Events Service.

## Installation Instructions - macOS

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host macOS machine:

-	Homebrew 2.0.1
-	VirtualBox 6.0.4
	-	VirtualBox Extension Pack 6.0.4
-	Vagrant 2.2.3 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 1.1.9
	-	vagrant-vbguest 0.17.2
-	Packer 1.3.4
-	Git 2.20.1
-	Optional Add-ons
	-	wget 1.20.1
	-	tree 1.8.0

Perform the following steps to install the needed software:

1.	Install the [Homebrew 2.0.1](https://brew.sh/) package manager for macOS 64-bit. Paste the following into a macOS Terminal prompt:  
    `$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`  

2.	Install [VirtualBox 6.0.4](https://www.virtualbox.org/) for macOS 64-bit.  
    `$ brew cask install virtualbox`  

3.	Install [VirtualBox Extension Pack 6.0.4](https://www.virtualbox.org/) for macOS 64-bit.  
    `$ brew cask install virtualbox-extension-pack`  

4.	Install [Vagrant 2.2.3]()https://www.vagrantup.com/ for macOS 64-bit.  
    `$ brew cask install vagrant`  

5.	Install [Packer 1.3.4](https://packer.io/) for macOS 64-bit.  
    `$ brew install packer`  

6.	Install [Git 2.20.1](https://git-scm.com/downloads) for macOS 64-bit.  
    `$ brew install git`  

7.	Install optional add-ons for macOS.  
    `$ brew install wget`  
    `$ brew install tree`  

### Configuration and Validation - macOS

1.	Validate installed command-line tools:

    ```
    $ brew --version
    Homebrew 2.0.1
    ...

    $ vboxmanage --version
    6.0.4r128413

    $ vagrant --version
    Vagrant 2.2.3

    $ packer --version
    1.3.4

    $ git --version
    git version 2.20.1
    ```

2.	Validate optional add-ons:

    ```
    $ wget --version
    $ tree --version
    ```

## Installation Instructions - Windows 64-Bit

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host Windows 64-Bit machine:

-	VirtualBox 6.0.4
	-	VirtualBox Extension Pack 6.0.4
-	Vagrant 2.2.3 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 1.1.9
	-	vagrant-vbguest 0.17.2
-	Packer 1.3.4
-	Git 2.20.1
-	Optional Add-ons for Git Bash
	-	wget 1.20.1
	-	tree 1.8.0

Perform the following steps to install the needed software:

1.	Install [VirtualBox 6.0.4 for Windows 64-bit](https://download.virtualbox.org/virtualbox/6.0.4/VirtualBox-6.0.4-128413-Win.exe).

2.	Install [VirtualBox Extension Pack 6.0.4](https://download.virtualbox.org/virtualbox/6.0.4/Oracle_VM_VirtualBox_Extension_Pack-6.0.4-128413.vbox-extpack).

3.	Install [Vagrant 2.2.3 for Windows 64-bit](https://releases.hashicorp.com/vagrant/2.2.3/vagrant_2.2.3_x86_64.msi).  
    Suggested install folder:  
    `C:\HashiCorp\vagrant`  

    **NOTE:** There is currently an issue on Windows 10 when using SSH to access the VM with Git Bash or Cygwin. To work-around, set the following environment variable:  
    ```
    export VAGRANT_PREFER_SYSTEM_BIN=1
    ```

    If this is set, Vagrant will prefer using utility executables (like `ssh` and `rsync`) from the local system instead of those vendored within the Vagrant installation.  

4.	Install [Packer 1.3.4 for Windows 64-bit](https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_windows_amd64.zip).
    Create suggested install folder and extract contents of ZIP file to:  
    `C:\HashiCorp\Packer\bin`  

5.	Install [Git 2.20.1 for Windows 64-bit](https://github.com/git-for-windows/git/releases/download/v2.20.1.windows.1/Git-2.20.1-64-bit.exe).

6.	Install optional add-ons for Git Bash.  
    Install [wget 1.9.1 for Windows](https://sourceforge.net/projects/mingw/files/Other/mingwPORT/Current%20Releases/wget-1.9.1-mingwPORT.tar.bz2/download).  
    Extract `wget-1.9.1\mingwPORT\wget.exe` to:  
    `C:\Program Files\Git\mingw64\bin`

    Install [tree 1.5.2.2 for Windows](https://sourceforge.net/projects/gnuwin32/files/tree/1.5.2.2/tree-1.5.2.2-bin.zip/download).  
    Extract `bin\tree.exe` to:  
    `C:\Program Files\Git\mingw64\bin`

### Configuration and Validation - Windows 64-Bit

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
    6.0.4r128413

    $ vagrant --version
    Vagrant 2.2.3

    $ packer --version
    1.3.4

    $ git --version
    git version 2.20.1.windows.1
    ```

6.	Validate optional add-ons for Git Bash:

    ```
    $ wget --version
    $ tree --version
    ```

## Complete Configuration and Validation

1.	Install or update the following Vagrant Plugins:

    ```
    $ vagrant plugin install vagrant-cachier -or-
    $ vagrant plugin update vagrant-cachier

    $ vagrant plugin install vagrant-share -or-
    $ vagrant plugin update vagrant-share

    $ vagrant plugin install vagrant-vbguest -or-
    $ vagrant plugin update vagrant-vbguest
    ```

2.	Validate Vagrant plugins:

    ```
    $ vagrant plugin list
    vagrant-cachier (1.2.1)
    vagrant-share (1.1.9, system)
    vagrant-vbguest (0.17.2)
    ```

3.	Configure Git for local user:

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

## Build the Vagrant Box Images

The DevOps 2.0 project now supports CentOS and Oracle VM builds. Click on a link below for platform-specific instructions and Bill-of-Materials.

-	[CentOS Linux 7 VMs](CENTOS_VM_BUILD_INSTRUCTIONS.md): Instructions
-	[Oracle Linux 7 VMs](ORACLE_VM_BUILD_INSTRUCTIONS.md): Instructions

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

-	Homebrew 4.4.16
	-	Command Line Tools (CLT) for Xcode
-	VirtualBox 7.0.14
	-	VirtualBox Extension Pack 7.0.14
-	Vagrant 2.4.3 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 2.0.0
	-	vagrant-vbguest 0.32.0
-	Packer 1.11.2
-	Git 2.48.0
-	jq 1.7.1
-	Optional Add-ons
	-	wget 1.25.0
	-	tree 2.2.1

Perform the following steps to install the needed software:

1.	Install [Command Line Tools (CLT) for Xcode](https://developer.apple.com/downloads).  
    `$ xcode-select --install`  

    > **NOTE:** Most Homebrew formulae require a compiler. A handful require a full Xcode installation. You can install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835), the [CLT](https://developer.apple.com/downloads), or both; Homebrew supports all three configurations. Downloading Xcode may require an Apple Developer account on older versions of Mac OS X. Sign up for free [here](https://developer.apple.com/register/index.action).  

2.	Install the [Homebrew 4.4.16](https://brew.sh/) package manager for macOS 64-bit. Paste the following into a macOS Terminal prompt:  
    `$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

3.	Install [VirtualBox 7.0.14](https://www.virtualbox.org/) for macOS 64-bit.  
    `$ brew cask install virtualbox`  

    > **NOTE:** With the release of macOS Mojave 10.14.5+, all new or updated kernel extensions must now be notarized by Apple. Due to this significant change, the VirtualBox installation will *fail* if you have upgraded to 10.14.5+. For a temporary work-around to this issue, perform the following prior to installing VirtualBox:
    >
    > **WARNING: For ADVANCED Users Only!!!**  
    > - Restart your workstation in Recovery Mode. (As the workstation restarts, hold down the Command (⌘)-R keys immediately upon hearing the startup chime. Hold the keys until the Apple logo appears.)
    > - Open the Terminal application and enter the following commands:
    >
    >   ```bash
    >   # spctl kext-consent add VB5E2TV963
    >   # spctl kext-consent list
    >   ```
    >
    > For additional details, please refer to the User Forum for VirtualBox [here](https://forums.virtualbox.org/viewtopic.php?f=8&t=93151&sid=637f4f3cf543d7ed3a47994b32ae4e93).

4.	Install [VirtualBox Extension Pack 7.0.14](https://www.virtualbox.org/) for macOS 64-bit.  
    `$ brew cask install virtualbox-extension-pack`  

5.	Install [Vagrant 2.4.3](https://www.vagrantup.com/) for macOS 64-bit.  
    `$ brew cask install vagrant`  

6.	Install [Packer 1.11.2](https://packer.io/) for macOS 64-bit.  
    `$ brew install hashicorp/tap/packer`  

7.	Install [Git 2.48.0](https://git-scm.com/downloads) for macOS 64-bit.  
    `$ brew install git`  

8.	Install [jq 1.7.1](https://jqlang.github.io/jq/) for macOS 64-bit.  
    `$ brew install jq`  

9.	Install optional add-ons for macOS.  
    `$ brew install wget`  
    `$ brew install tree`  

### Configuration and Validation - macOS

1.	Validate installed command-line tools:

    ```bash
    $ brew --version
    Homebrew 4.4.16
    $ brew doctor
    Your system is ready to brew.
    ...

    $ vboxmanage --version
    7.0.14r161095

    $ vagrant --version
    Vagrant 2.4.3

    $ packer --version
    1.11.2

    $ git --version
    git version 2.48.0

    $ jq --version
    jq-1.7.1
    ```

2.	Validate optional add-ons:

    ```bash
    $ wget --version
    $ tree --version
    ```

## Installation Instructions - Windows 64-Bit

To build the DevOps 2.0 [VirtualBox](https://www.virtualbox.org/) VMs, the following open source software needs to be installed on the host Windows 64-Bit machine:

-	VirtualBox 7.0.14
	-	VirtualBox Extension Pack 7.0.14
-	Vagrant 2.4.3 with Plugins
	-	vagrant-cachier 1.2.1
	-	vagrant-share 2.0.0
	-	vagrant-vbguest 0.32.0
-	Packer 1.11.2
-	Git 2.47.1
-	jq 1.7.1
-	Optional Add-ons for Git Bash
	-	wget 1.9.1
	-	tree 1.5.2.2

Perform the following steps to install the needed software:

1.	Install [VirtualBox 7.0.14 for Windows 64-bit](https://download.virtualbox.org/virtualbox/7.0.14/VirtualBox-7.0.14-161095-Win.exe).

2.	Install [VirtualBox Extension Pack 7.0.14](https://download.virtualbox.org/virtualbox/7.0.14/Oracle_VM_VirtualBox_Extension_Pack-7.0.14-161095.vbox-extpack).

3.	Install [Vagrant 2.4.3 for Windows 64-bit](https://releases.hashicorp.com/vagrant/2.4.3/vagrant_2.4.3_windows_amd64.msi).  
    Suggested install folder:  
    `C:\HashiCorp\vagrant`  

    > **NOTE:** There is currently an issue on Windows 10 when using SSH to access the VM with Git Bash or Cygwin. To work-around, set the following environment variable:  
    > ```bash
    > export VAGRANT_PREFER_SYSTEM_BIN=1
    > ```
    >
    > If this is set, Vagrant will prefer using utility executables (like `ssh` and `rsync`) from the local system instead of those vendored within the Vagrant installation.  

4.	Install [Packer 1.11.2 for Windows 64-bit](https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_windows_amd64.zip).
    Create suggested install folder and extract contents of ZIP file to:  
    `C:\HashiCorp\Packer\bin`  

5.	Install [Git 2.47.1 for Windows 64-bit](https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe) for Windows 64-bit.

6.	Install [jq 1.7.1](https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-win64.exe) for Windows 64-bit.  
    Create suggested install folder and rename binary to:  
    `C:\Program Files\Git\usr\local\bin\jq.exe`

7.	Install optional add-ons for Git Bash.  
    Install [wget 1.9.1 for Windows](https://sourceforge.net/projects/mingw/files/Other/mingwPORT/Current%20Releases/wget-1.9.1-mingwPORT.tar.bz2/download).  
    Extract `wget-1.9.1\mingwPORT\wget.exe` to:  
    `C:\Program Files\Git\mingw64\bin`

    Install [tree 1.5.2.2 for Windows](https://sourceforge.net/projects/gnuwin32/files/tree/1.5.2.2/tree-1.5.2.2-bin.zip/download).  
    Extract `bin\tree.exe` to:  
    `C:\Program Files\Git\mingw64\bin`

### Configuration and Validation - Windows 64-Bit

1.	Set Windows Environment `PATH` to:

    ```bash
    PATH=C:\HashiCorp\Vagrant\bin;C:\HashiCorp\Packer\bin;C:\Program Files\Git\usr\local\bin;C:\Program Files\Oracle\VirtualBox;%PATH%
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

    ```bash
    $ VBoxManage --version
    7.0.14r161095

    $ vagrant --version
    Vagrant 2.4.3

    $ packer --version
    1.11.2

    $ git --version
    git version 2.47.1.windows.1

    $ jq --version
    jq-1.7.1
    ```

6.	Validate optional add-ons for Git Bash:

    ```bash
    $ wget --version
    $ tree --version
    ```

## Complete Configuration and Validation

1.	Install or update the following Vagrant Plugins:

    ```bash
    $ vagrant plugin install vagrant-cachier -or-
    $ vagrant plugin update vagrant-cachier

    $ vagrant plugin install vagrant-share -or-
    $ vagrant plugin update vagrant-share

    $ vagrant plugin install vagrant-vbguest -or-
    $ vagrant plugin update vagrant-vbguest
    ```

2.	Validate Vagrant plugins:

    ```bash
    $ vagrant plugin list
    vagrant-cachier (1.2.1)
    vagrant-share (2.0.0, system)
    vagrant-vbguest (0.32.0)
    ```

3.	Configure Git for local user:

    ```bash
    $ git config --global user.name "<your_name>"
    $ git config --global user.email "<your_email>"
    $ git config --global --list
    ```

## Get the Code

1.	Create a folder for your DevOps 2.0 project:

    ```bash
    $ mkdir -p /<drive>/projects
    $ cd /<drive>/projects
    ```

2.	Get the code from GitHub:

    ```bash
    $ git clone https://github.com/ed-barberis/devops-2.0.git devops-2.0
    $ cd devops-2.0
    $ git submodule update --init --recursive
    ```

## Build the Vagrant Box Images

The DevOps 2.0 project now supports CentOS and Oracle VM builds. Click on a link below for platform-specific instructions and Bill-of-Materials.

-	[CentOS Linux 7 VMs](CENTOS_VM_BUILD_INSTRUCTIONS.md): Instructions
-	[Oracle Linux 7 VMs](ORACLE_VM_BUILD_INSTRUCTIONS.md): Instructions

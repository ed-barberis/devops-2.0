# Data ---------------------------------------------------------------------------------------------
data "external-raw" "host_os" {
  program = ["uname", "-s"]
}

# Locals -------------------------------------------------------------------------------------------
locals {
  # helper locals.
  build_dir = abspath("${path.root}/../../../../artifacts/${var.os_name}/")
  host_os   = chomp(data.external-raw.host_os.result)

  # source block provider specific.
  # parallels-iso.
  parallels_tools_flavor = var.parallels_tools_flavor == null ? (
    var.is_windows ? (
      var.os_arch == "x86_64" ? "win" : "win-arm"
      ) : (
      var.os_arch == "x86_64" ? "lin" : "lin-arm"
    )
  ) : var.parallels_tools_flavor

  parallels_tools_mode = var.parallels_tools_mode == null ? (
    var.is_windows ? "attach" : "upload"
  ) : var.parallels_tools_mode

  parallels_prlctl = var.parallels_prlctl == null ? (
    var.is_windows ? (
      var.os_arch == "x86_64" ? [
        ["set", "{{ .Name }}", "--efi-boot", "off"]
        ] : [
        ["set", "{{ .Name }}", "--efi-boot", "on"],
        ["set", "{{ .Name }}", "--efi-secure-boot", "off"],
      ]
      ) : (
      var.os_name == "freebsd" && var.os_arch == "x86_64" ? [
        ["set", "{{ .Name }}", "--bios-type", "efi64"],
        ["set", "{{ .Name }}", "--efi-boot", "on"],
        ["set", "{{ .Name }}", "--efi-secure-boot", "off"],
        ] : [
        ["set", "{{ .Name }}", "--3d-accelerate", "off"],
        ["set", "{{ .Name }}", "--videosize", "16"]
      ]
    )
  ) : var.parallels_prlctl

  # virtualbox-iso.
  vbox_firmware = var.vbox_firmware == null ? (
    var.os_arch == "aarch64" ? "efi" : "bios"
  ) : var.vbox_firmware

  vbox_gfx_controller = var.vbox_gfx_controller == null ? (
    var.is_windows ? "vboxsvga" : "vmsvga"
  ) : var.vbox_gfx_controller

  vbox_gfx_vram_size = var.vbox_gfx_controller == null ? (
    var.is_windows ? 128 : 33
  ) : var.vbox_gfx_vram_size

  vbox_guest_additions_mode = var.vbox_guest_additions_mode == null ? (
    var.is_windows ? "attach" : "upload"
  ) : var.vbox_guest_additions_mode

  vbox_hard_drive_interface = var.vbox_hard_drive_interface == null ? (
    var.os_arch == "aarch64" ? "virtio" : "sata"
  ) : var.vbox_hard_drive_interface

  vbox_iso_interface = var.vbox_iso_interface == null ? (
    var.os_arch == "aarch64" ? "virtio" : "sata"
  ) : var.vbox_iso_interface

  vboxmanage = var.vboxmanage == null ? (
    var.os_arch == "aarch64" ? [
      ["modifyvm", "{{.Name}}", "--chipset", "armv8virtual"],
      ["modifyvm", "{{.Name}}", "--audio-enabled", "off"],
      ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
      ["modifyvm", "{{.Name}}", "--cableconnected1", "on"],
      ["modifyvm", "{{.Name}}", "--usb-xhci", "on"],
      ["modifyvm", "{{.Name}}", "--graphicscontroller", "qemuramfb"],
      ["modifyvm", "{{.Name}}", "--mouse", "usb"],
      ["modifyvm", "{{.Name}}", "--keyboard", "usb"],
      ["storagectl", "{{.Name}}", "--name", "IDE Controller", "--remove"],
      ] : [
      ["modifyvm", "{{.Name}}", "--chipset", "ich9"],
      ["modifyvm", "{{.Name}}", "--audio-enabled", "off"],
      ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
      ["modifyvm", "{{.Name}}", "--cableconnected1", "on"],
    ]
  ) : var.vboxmanage

  vbox_nic_type = var.vbox_nic_type == null ? (
    var.os_name == "freebsd" ? "82545EM" : null
  ) : var.vbox_nic_type

  # source block common.
  cd_files = var.cd_files == null ? (
    var.is_windows ? (
      var.os_arch == "x86_64" ? (
        var.hyperv_generation == 2 ? [
          "${path.root}/../../../submodules/chef/bento/packer_templates/win_answer_files/${var.os_version}/hyperv-gen2/Autounattend.xml",
          ] : [
          "${path.root}/../../../submodules/chef/bento/packer_templates/win_answer_files/${var.os_version}/Autounattend.xml",
        ]
        ) : [
        "${path.root}/../../../submodules/chef/bento/packer_templates/win_answer_files/${var.os_version}/arm64/Autounattend.xml",
      ]
    ) : null
  ) : var.cd_files

  communicator = var.communicator == null ? (
    var.is_windows ? "winrm" : "ssh"
  ) : var.communicator

  default_boot_command = var.boot_command

  default_boot_wait = var.default_boot_wait == null ? (
    var.is_windows ? "60s" : "10s"
  ) : var.default_boot_wait

  disk_size = var.disk_size == null ? (
    var.is_windows ? 131072 : 65536
  ) : var.disk_size

  floppy_files = var.floppy_files == null ? (
    var.is_windows ? (
      var.os_arch == "x86_64" ? [
        "${path.root}/../../../submodules/chef/bento/packer_templates/win_answer_files/${var.os_version}/Autounattend.xml",
      ] : null
    ) : null
  ) : var.floppy_files

  http_directory  = var.http_directory == null ? "${path.root}/../../../submodules/chef/bento/packer_templates/http" : var.http_directory
  iso_target_path = var.iso_target_path == "build_dir_iso" && var.iso_url != null ? "${path.root}/../../../../artifacts/${var.os_name}/iso/${var.os_name}-${var.os_version}-${var.os_arch}-${substr(sha256(var.iso_url), 0, 8)}.iso" : var.iso_target_path

  memory = var.memory == null ? (
    var.is_windows || var.os_name == "macos" || var.os_arch == "aarch64" ? 4096 : 3072
  ) : var.memory

  output_directory = var.output_directory == null ? "${path.root}/../../../../artifacts/${var.os_name}/build_files/packer-${var.os_name}-${var.os_version}-${var.os_arch}" : var.output_directory

  shutdown_command = var.shutdown_command == null ? (
    var.is_windows ? "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"" : (
      var.os_name == "macos" ? "echo 'vagrant' | sudo -S shutdown -h now" : (
        var.os_name == "freebsd" ? "echo 'vagrant' | su -m root -c 'shutdown -p now'" : "echo 'vagrant' | sudo -S /sbin/halt -h -p"
      )
    )
  ) : var.shutdown_command

  vm_name = var.vm_name == null ? (
    var.os_arch == "x86_64" ? "${var.os_name}-${var.os_version}-amd64" : "${var.os_name}-${var.os_version}-${var.os_arch}"
  ) : var.vm_name
}

# Sources ------------------------------------------------------------------------------------------
source "parallels-iso" "vm" {
  # parallels specific options.
  guest_os_type          = var.parallels_guest_os_type
  parallels_tools_flavor = local.parallels_tools_flavor
  parallels_tools_mode   = local.parallels_tools_mode
  prlctl                 = local.parallels_prlctl
  prlctl_version_file    = var.parallels_prlctl_version_file

  # source block common options.
  boot_command     = var.parallels-iso_boot_command == null ? local.default_boot_command : var.parallels_boot_command
  boot_wait        = var.parallels_boot_wait == null ? local.default_boot_wait : var.parallels_boot_wait
  cd_content       = var.cd_content
  cd_files         = local.cd_files
  cd_label         = var.cd_label
  cpus             = var.cpus
  communicator     = local.communicator
  disk_size        = local.disk_size
  floppy_files     = local.floppy_files
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_target_path  = local.iso_target_path
  iso_url          = var.iso_url
  memory           = local.memory
  output_directory = "${local.output_directory}-parallels"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  winrm_password   = var.winrm_password
  winrm_timeout    = var.winrm_timeout
  winrm_username   = var.winrm_username
  vm_name          = local.vm_name
}

source "virtualbox-iso" "vm" {
  # virtualbox specific options.
  firmware                  = local.vbox_firmware
  gfx_controller            = local.vbox_gfx_controller
  gfx_vram_size             = local.vbox_gfx_vram_size
  guest_additions_path      = var.vbox_guest_additions_path
  guest_additions_mode      = local.vbox_guest_additions_mode
  guest_additions_interface = var.vbox_guest_additions_interface
  guest_os_type             = var.vbox_guest_os_type
  hard_drive_interface      = local.vbox_hard_drive_interface
  iso_interface             = local.vbox_iso_interface
  nic_type                  = local.vbox_nic_type
  rtc_time_base             = var.vbox_rtc_time_base
  vboxmanage                = local.vboxmanage
  virtualbox_version_file   = var.virtualbox_version_file

  # source block common options.
  boot_command     = var.vbox_boot_command == null ? local.default_boot_command : var.vbox_boot_command
  boot_wait        = var.vbox_boot_wait == null ? local.default_boot_wait : var.vbox_boot_wait
  cd_content       = var.cd_content
  cd_files         = local.cd_files
  cd_label         = var.cd_label
  cpus             = var.cpus
  communicator     = local.communicator
  disk_size        = local.disk_size
  floppy_files     = local.floppy_files
  headless         = var.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_target_path  = local.iso_target_path
  iso_url          = var.iso_url
  memory           = local.memory
  output_directory = "${local.output_directory}-virtualbox"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  winrm_password   = var.winrm_password
  winrm_timeout    = var.winrm_timeout
  winrm_username   = var.winrm_username
  vm_name          = local.vm_name
}

source "virtualbox-ovf" "vm" {
  # virtualbox specific options.
  guest_additions_path    = var.vbox_guest_additions_path
  source_path             = var.vbox_source_path
  checksum                = var.vbox_checksum
  vboxmanage              = local.vboxmanage
  virtualbox_version_file = var.virtualbox_version_file

  # source block common options.
  communicator     = local.communicator
  headless         = var.headless
  output_directory = "${local.output_directory}-virtualbox-ovf"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  vm_name          = local.vm_name
}

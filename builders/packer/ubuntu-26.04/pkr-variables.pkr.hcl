# Variables ----------------------------------------------------------------------------------------
# general variables.
variable "os_name" {
  type        = string
  description = "OS Brand Name."
}

variable "os_version" {
  type        = string
  description = "OS version number."
}

variable "os_arch" {
  type        = string
  description = "OS architecture type, x86_64 or aarch64."

  validation {
    condition     = var.os_arch == "x86_64" || var.os_arch == "aarch64"
    error_message = "The OS architecture type should be either x86_64 or aarch64."
  }
}

variable "is_windows" {
  type        = bool
  default     = false
  description = "Determines to set setting for Windows or Linux."
}

variable "http_proxy" {
  type        = string
  default     = env("http_proxy")
  description = "Http proxy url to connect to the internet."
}

variable "https_proxy" {
  type        = string
  default     = env("https_proxy")
  description = "Https proxy url to connect to the internet."
}

variable "no_proxy" {
  type        = string
  default     = env("no_proxy")
  description = "No Proxy."
}

variable "sources_enabled" {
  type        = list(string)
  default     = [
    "source.parallels-iso.vm",
    "source.virtualbox-iso.vm",
  ]
  description = "Build Sources to use for building vagrant boxes."
}

# source block provider specific variables.
# parallels-iso.
variable "parallels-iso_boot_command" {
  type        = list(string)
  default     = null
  description = "Commands to pass to gui session to initiate automated install."
}

variable "parallels_boot_wait" {
  type    = string
  default = null
}

variable "parallels_guest_os_type" {
  type        = string
  default     = null
  description = "OS type for virtualization optimization."
}

variable "parallels_tools_flavor" {
  type    = string
  default = null
}

variable "parallels_tools_mode" {
  type    = string
  default = null
}

variable "parallels_prlctl" {
  type    = list(list(string))
  default = null
}

variable "parallels_prlctl_version_file" {
  type    = string
  default = ".prlctl_version"
}

# virtualbox-iso.
variable "vbox_boot_command" {
  type        = list(string)
  default     = null
  description = "Commands to pass to gui session to initiate automated install."
}

variable "vbox_boot_wait" {
  type    = string
  default = null
}

variable "vbox_firmware" {
  type        = string
  default     = null
  description = "Firmware type, takes bios or efi."
}

variable "vbox_gfx_controller" {
  type    = string
  default = null
}

variable "vbox_gfx_vram_size" {
  type    = number
  default = null
}

variable "vbox_guest_additions_interface" {
  type    = string
  default = null
}

variable "vbox_guest_additions_mode" {
  type    = string
  default = null
}

variable "vbox_guest_additions_path" {
  type    = string
  default = "VBoxGuestAdditions_{{ .Version }}.iso"
}

variable "vbox_guest_os_type" {
  type        = string
  default     = null
  description = "OS type for virtualization optimization."
}

variable "vbox_hard_drive_interface" {
  type    = string
  default = null
}

variable "vbox_iso_interface" {
  type    = string
  default = null
}

variable "vboxmanage" {
  type    = list(list(string))
  default = null
}

variable "vbox_nic_type" {
  type    = string
  default = null
}

variable "virtualbox_version_file" {
  type    = string
  default = ".vbox_version"
}

variable "vbox_rtc_time_base" {
  type        = string
  default     = "UTC"
  description = "RTC time base."
}

# virtualbox-ovf.
variable "vbox_source_path" {
  type        = string
  default     = null
  description = "Path to the OVA/OVF file."
}

variable "vbox_checksum" {
  type        = string
  default     = null
  description = "Checksum of the OVA/OVF file."
}

# source block common variables.
variable "boot_command" {
  type        = list(string)
  default     = null
  description = "Commands to pass to gui session to initiate automated install."
}

variable "default_boot_wait" {
  type    = string
  default = null
}

variable "cd_content" {
  type        = map(string)
  default     = null
  description = "Content to be served by the cdrom."
}

variable "cd_files" {
  type    = list(string)
  default = null
}

variable "cd_label" {
  type    = string
  default = "cidata"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "communicator" {
  type    = string
  default = null
}

variable "devops_home" {
  type    = string
  default = "/opt/devops-2.0"
}

variable "disk_size" {
  type    = number
  default = 65536
}

variable "floppy_files" {
  type    = list(string)
  default = null
}

variable "headless" {
  type        = bool
  default     = true
  description = "Start GUI window to interact with VM."
}

variable "http_directory" {
  type    = string
  default = null
}

variable "iso_checksum" {
  type        = string
  default     = null
  description = "ISO download checksum."
}

variable "iso_target_path" {
  type        = string
  default     = "build_dir_iso"
  description = "Path to store the ISO file. Null will use packer cache default or build_dir_iso will put it in the local build/iso directory."
}

variable "iso_url" {
  type        = string
  default     = null
  description = "ISO download url."
}

variable "memory" {
  type    = number
  default = null
}

variable "output_directory" {
  type    = string
  default = null
}

variable "shutdown_command" {
  type    = string
  default = null
}

variable "shutdown_timeout" {
  type    = string
  default = "15m"
}

variable "ssh_group" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "ssh_timeout" {
  type    = string
  default = "15m"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "winrm_password" {
  type    = string
  default = "vagrant"
}

variable "winrm_timeout" {
  type    = string
  default = "60m"
}

variable "winrm_username" {
  type    = string
  default = "vagrant"
}

variable "vm_domain" {
  type    = string
  default = "localdomain"
}

variable "vm_hostname" {
  type    = string
  default = "lpad"
}

variable "vm_name" {
  type    = string
  default = null
}

# builder common block.
variable "aws_cli_default_output_format" {
  type    = string
  default = "${env("aws_cli_default_output_format")}"
}

variable "aws_cli_default_region_name" {
  type    = string
  default = "${env("aws_cli_default_region_name")}"
}

variable "aws_cli_user_config" {
  type    = string
  default = "${env("aws_cli_user_config")}"
}

variable "docker_completion_release" {
  type    = string
  default = "29.6.2"
}

variable "mongodb_enable_access_control" {
  type    = string
  default = "true"
}

variable "nodejs_release" {
  type    = string
  default = "--lts"
}

variable "npm_release" {
  type    = string
  default = "latest"
}

variable "scripts" {
  type    = list(string)
  default = null
}

variable "serverless_release" {
  type    = string
  default = "latest"
}

variable "tomcat_admin_roles" {
  type    = string
  default = "manager-gui,admin-gui"
}

variable "tomcat_jdk_home" {
  type    = string
  default = "/usr/local/java/jdk17"
}

variable "tomcat_catalina_opts" {
  type    = string
  default = "-Xms1024m -Xmx2048m -server -XX:+UseParallelGC"
}

variable "tomcat_enable_service" {
  type    = string
  default = "true"
}

variable "tomcat_manager_apps_remote_access" {
  type    = string
  default = "true"
}

variable "user_docker_profile" {
  type    = string
  default = "true"
}

# splunk enterprise install user variables.
variable "splunk_ssh_username" {
  type        = string
  default     = "splunk"
  description = "Splunk Enterprise install user name."
}

variable "splunk_ssh_group" {
  type    = string
  default = "splunk"
  description = "Splunk Enterprise install group name."
}

variable "splunk_user_password" {
  type    = string
  default = "Welcome1"
  description = "Splunk Enterprise install user password."
}

variable "splunk_user_comment" {
  type    = string
  default = "Splunk Enterprise install user"
  description = "Splunk Enterprise install user comment."
}

variable "splunk_user_sudo_privileges" {
  type    = string
  default = "true"
  description = "Splunk Enterprise install user sudo privileges boolean."
}

variable "splunk_user_home" {
  type    = string
  default = "/opt/splunk"
  description = "Splunk Enterprise install user home directory."
}

variable "splunk_user_login_shell" {
  type    = string
  default = "/bin/bash"
  description = "Splunk Enterprise install user login shell."
}

variable "splunk_user_install_headless_env" {
  type    = string
  default = "true"
  description = "Splunk Enterprise install user headless environment boolean."
}

variable "splunk_user_docker_profile" {
  type    = string
  default = "false"
  description = "Splunk Enterprise install user docker profile boolean."
}

variable "splunk_user_prompt_color" {
  type    = string
  default = "red_orange"
  description = "Splunk Enterprise install user prompt color."

  validation {
    condition     = contains(["black", "blue", "cyan", "green", "magenta", "red", "white", "yellow", "orange", "red_orange"], var.splunk_user_prompt_color)
    error_message = "User prompt color must be one of: 'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow, 'orange, 'or 'red_orange'. Got: 'var.splunk_user_prompt_color'."
  }
}

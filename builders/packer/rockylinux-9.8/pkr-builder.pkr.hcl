# Locals -------------------------------------------------------------------------------------------
locals {
  source_names = [for source in var.sources_enabled : trimprefix(source, "source.")]
}

# Build --------------------------------------------------------------------------------------------
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = var.sources_enabled

  # linux shell scripts.
  provisioner "shell" {
    inline = [
      "sudo hostnamectl | awk '/Operating System/ {print $0}'",
      "sudo mkdir -p ${var.devops_home}/provisioners/scripts",
      "sudo chown -R ${var.ssh_username}:${var.ssh_password} ${var.devops_home}"
    ]
  }

  provisioner "file" {
    destination = "${var.devops_home}/provisioners/scripts"
    source      = "${path.root}/../../../provisioners/scripts/"
  }

  provisioner "shell" {
    inline = [
      "sudo chown -R root:root ${var.devops_home}"
    ]
  }

  # install updates and reboot.
  provisioner "shell" {
    environment_vars  = [
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = [
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/_common/update_packages.sh"
    ]
    valid_exit_codes  = [0, 143]
  }

  provisioner "shell" {
    inline = [
      "echo 'After reboot'"
    ]
    pause_after = "10s"
  }

  # install build tools and reboot.
  provisioner "shell" {
    environment_vars  = [
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = [
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/_common/build_tools.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'After reboot'"
    ]
    pause_after = "10s"
  }

  # run common scripts and guest tools installation.
  provisioner "shell" {
    environment_vars  = [
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
      "vm_domain=${var.vm_domain}",
      "vm_hostname=${var.vm_hostname}"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = [
      "${path.root}/../../../provisioners/scripts/common/config_systemd_hostname.sh",
      "${path.root}/../../../provisioners/scripts/common/motd.sh",
      "${path.root}/../../../provisioners/scripts/common/vagrant.sh",
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/_common/sshd.sh",
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/_common/guest_tools_virtualbox.sh",
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/_common/guest_tools_parallels.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'After reboot'"
    ]
    pause_after = "10s"
  }

  # run os specific scripts.
  provisioner "shell" {
    environment_vars  = [
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    scripts           = [
      "${path.root}/../../../provisioners/scripts/centos/install_centos8_repositories.sh"
    ]
  }

  provisioner "shell" {
    expect_disconnect = true
    inline = [
      "sudo dnf -y upgrade",
      "sudo systemctl reboot"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'After reboot'"
    ]
    pause_after = "10s"
  }

  # install rust for 'root' user in order to compile git.
  provisioner "shell" {
    environment_vars  = [
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
      "user_name=root"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = [
      "${path.root}/../../../provisioners/scripts/common/install_rust.sh"
    ]
  }

  # run devops-2.0 project scripts.
  provisioner "shell" {
    environment_vars  = [
      "aws_cli_user_config=${var.aws_cli_user_config}",
      "aws_cli_default_region_name=${var.aws_cli_default_region_name}",
      "aws_cli_default_output_format=${var.aws_cli_default_output_format}",
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
      "user_name=${var.ssh_username}",
      "user_group=${var.ssh_group}",
      "user_docker_profile=${var.user_docker_profile}",
      "mongodb_enable_access_control=${var.mongodb_enable_access_control}",
      "nodejs_release=${var.nodejs_release}",
      "npm_release=${var.npm_release}",
      "serverless_release=${var.serverless_release}",
      "tomcat_username=${var.ssh_username}",
      "tomcat_group=${var.ssh_group}",
      "tomcat_admin_roles=${var.tomcat_admin_roles}",
      "tomcat_jdk_home=${var.tomcat_jdk_home}",
      "tomcat_catalina_opts=${var.tomcat_catalina_opts}",
      "tomcat_enable_service=${var.tomcat_enable_service}",
      "tomcat_manager_apps_remote_access=${var.tomcat_manager_apps_remote_access}"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    pause_before      = "60s"
    scripts           = [
      "${path.root}/../../../provisioners/scripts/centos/install_centos9_headless_devops_tools.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_corretto_java_jdk_8.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_corretto_java_jdk_11.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_corretto_java_jdk_17.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_corretto_java_jdk_21.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_corretto_java_jdk_25.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_corretto_java_jdk_26.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos9_python3.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_fedora_podman.sh",
      "${path.root}/../../../provisioners/scripts/common/install_podman_compose.sh",
      "${path.root}/../../../provisioners/scripts/common/install_ansible.sh",
      "${path.root}/../../../provisioners/scripts/common/install_appdynamics_ansible_collection.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_cli_2.sh",
      "${path.root}/../../../provisioners/scripts/common/install_jq_json_processor.sh",
      "${path.root}/../../../provisioners/scripts/common/install_yq_yaml_processor.sh",
      "${path.root}/../../../provisioners/scripts/common/install_hashicorp_consul.sh",
      "${path.root}/../../../provisioners/scripts/common/install_hashicorp_packer.sh",
      "${path.root}/../../../provisioners/scripts/common/install_hashicorp_terraform.sh",
      "${path.root}/../../../provisioners/scripts/common/install_hashicorp_vault.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos8_git.sh",
      "${path.root}/../../../provisioners/scripts/common/install_git_flow.sh",
      "${path.root}/../../../provisioners/scripts/common/install_fastfetch_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_aws_eksctl_cli.sh",
#     "${path.root}/../../../provisioners/scripts/common/install_aws_kubectl_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_kubectl_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_k9s_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_helm_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_helmfile_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_jsonnet_bundler_package_manager.sh",
      "${path.root}/../../../provisioners/scripts/common/install_grafana_tanka_cli.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos8_vim_9.sh",
      "${path.root}/../../../provisioners/scripts/common/install_headless_root_user_env.sh",
      "${path.root}/../../../provisioners/scripts/common/install_headless_user_env.sh",
      "${path.root}/../../../provisioners/scripts/common/install_apache_ant.sh",
      "${path.root}/../../../provisioners/scripts/common/install_apache_maven.sh",
      "${path.root}/../../../provisioners/scripts/common/install_apache_groovy.sh",
      "${path.root}/../../../provisioners/scripts/common/install_gradle.sh",
      "${path.root}/../../../provisioners/scripts/common/install_google_golang.sh",
      "${path.root}/../../../provisioners/scripts/common/install_rust.sh",
#     "${path.root}/../../../provisioners/scripts/common/install_onefetch_cli.sh",
      "${path.root}/../../../provisioners/scripts/common/install_scala3_lang.sh",
      "${path.root}/../../../provisioners/scripts/common/install_scala_sbt.sh",
      "${path.root}/../../../provisioners/scripts/common/install_jmespath_jp_json_processor.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos8_xmlstarlet_xml_processor.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos8_mongodb_community_server_8.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos7_apache_tomcat_10_1.sh",
#     "${path.root}/../../../provisioners/scripts/centos/install_centos9_mariadb_community_server_11.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos9_oracle_mysql_community_server_84.sh",
      "${path.root}/../../../provisioners/scripts/centos/install_centos9_oracle_mysql_shell_84.sh",
#     "${path.root}/../../../provisioners/scripts/common/install_appdynamics_java_agent.sh",
#     "${path.root}/../../../provisioners/scripts/common/install_centos7_appdynamics_machine_agent.sh",
      "${path.root}/../../../provisioners/scripts/common/install_nodejs_javascript_runtime.sh",
#     "${path.root}/../../../provisioners/scripts/common/install_appdynamics_nodejs_serverless_tracer.sh",
      "${path.root}/../../../provisioners/scripts/common/install_serverless_framework_cli.sh"
    ]
  }

  # run cleanup and minimize scripts.
  provisioner "shell" {
    environment_vars  = [
      "devops_home=${var.devops_home}",
      "HOME_DIR=/home/${var.ssh_username}",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}"
    ]
    execute_command   = "echo '${var.ssh_password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    expect_disconnect = true
    pause_before      = "10s"
    scripts           = [
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/rhel/cleanup_dnf.sh",
      "${path.root}/../../../submodules/chef/bento/packer_templates/scripts/_common/minimize.sh"
    ]
  }

  # fix vagrant errors while provisioning vm with parallels.
  provisioner "shell" {
    # This provisioner only runs for the 'parallels-iso.vm' source.
    only = ["parallels-iso.vm"]

    inline = [
      "echo 'Renaming /etc/hostname to fix Vagrant error while updating VM hostname...'",
      "sudo mv -f /etc/hostname /etc/hostname.orig",
      "echo 'Renaming /usr/bin/prlfsmountd to fix error allowing Vagrant to manage synced folders and not Parallels Desktop...'",
      "sudo mv -f /usr/bin/prlfsmountd /usr/bin/prlfsmountd.orig"
    ]
  }

  # convert machines to vagrant boxes.
  post-processor "vagrant" {
    compression_level    = 9
    output               = "${path.root}/../../../../artifacts/rockylinux/rockylinux-${var.os_version}-${var.os_arch}.{{ .Provider }}.box"
    vagrantfile_template = null
  }
}

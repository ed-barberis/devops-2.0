packer {
  required_version = ">= 1.16.0"

  required_plugins {
    external = {
      version = ">= 0.0.3"
      source  = "github.com/joomcode/external"
    }

    parallels = {
      version = ">= 1.2.8"
      source  = "github.com/parallels/parallels"
    }

#   vagrant = {
#     version = ">= 1.1.7"
#     source  = "github.com/hashicorp/vagrant"
#   }

#   virtualbox = {
#     version = ">= 1.1.5"
#     source  = "github.com/hashicorp/virtualbox"
#   }
  }
}

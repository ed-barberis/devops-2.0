#!/bin/sh -eux
# install amazon aws command line interface (cli).

# set default values for input environment variables if not set. ---------------
user_name="${user_name:-vagrant}"                               # [optional] user name (defaults to 'vagrant').
user_config_aws_cli="${user_config_aws_cli:-false}"             # [optional] configure aws cli for user? (boolean defaults to 'false').
                                                                #
                                                                # NOTE: if 'user_config_aws_cli' is 'true'--
                                                                #       the following pass-thru env variables must be defined:
aws_access_key_id="${aws_access_key_id:-}"                      # aws access key id.
aws_secret_access_key="${aws_secret_access_key:-}"              # aws secret access key.
aws_default_region_name="${aws_default_region_name:-us-east-2}" # [optional] aws default region name (defaults to 'us-east-2' [Ohio]).
aws_default_output_format="${aws_default_output_format:-json}"  # [optional] aws default output format (defaults to 'json').
                                                                #            valid output formats:
                                                                #              'json', 'text', 'table'

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="vagrant"                          # [optional] user name (defaults to 'vagrant').
    [root]# export user_config_aws_cli="true"                   # [optional] configure aws cli for user? (boolean defaults to 'false').
                                                                #
                                                                # NOTE: if 'user_config_aws_cli' is 'true'--
                                                                #       the following pass-thru env variables must be defined:
    [root]# export aws_access_key_id="<YourKeyID>"              # aws access key id.
    [root]# export aws_secret_access_key="<YourSecretKey>"      # aws secret access key.
    [root]# export aws_default_region_name="us-east-2"          # [optional] aws default region name (defaults to 'us-east-2' [Ohio]).
    [root]# export aws_default_output_format="json"             # [optional] aws default output format (defaults to 'json').
                                                                #            valid output formats:
                                                                #              'json', 'text', 'table'
    [root]# $0
EOF
}

# validate environment variables. ----------------------------------------------
if [ "$user_config_aws_cli" == "true" ]; then
  if [ -z "$aws_access_key_id" ]; then
    echo "Error: 'aws_access_key_id' environment variable not set."
    usage
    exit 1
  fi

  if [ -z "$aws_secret_access_key" ]; then
    echo "Error: 'aws_secret_access_key' environment variable not set."
    usage
    exit 1
  fi

  if [ -n "$aws_default_output_format" ]; then
    case $aws_default_output_format in
        json|text|table)
          ;;
        *)
          echo "Error: invalid 'aws_default_output_format'."
          usage
          exit 1
          ;;
    esac
  fi
fi

# verify pip installation. -----------------------------------------------------
runuser -c "PATH=/home/${user_name}/.local/bin:${PATH} pip --version" - ${user_name}

# install aws cli. -------------------------------------------------------------
runuser -c "PATH=/home/${user_name}/.local/bin:${PATH} pip install awscli --upgrade --user" - ${user_name}

# verify installation.
runuser -c "PATH=/home/${user_name}/.local/bin:${PATH} aws --version" - ${user_name}

# configure the aws cli client. ------------------------------------------------
if [ "$user_config_aws_cli" == "true" ]; then
  # NOTE: if 'user_config_aws_cli' is 'true'--
  #       the following pass-thru env variables must be defined:
  #         aws_access_key_id:                              # aws access key id.
  #         aws_secret_access_key:                          # aws secret access key.
  #         aws_default_region_name:                        # [optional] aws default region name (defaults to 'us-east-2' [Ohio]).
  #         aws_default_output_format:                      # [optional] aws default output format (defaults to 'json').
  #           valid output formats:
  #             'json', 'text', 'table'
  aws_config_cmd=$(printf "aws configure <<< \$\'%s\\\\n%s\\\\n%s\\\\n%s\\\\n\'\n" ${aws_access_key_id} ${aws_secret_access_key} ${aws_default_region_name} ${aws_default_output_format})
  runuser -c "PATH=/home/${user_name}/.local/bin:${PATH} eval ${aws_config_cmd}" - ${user_name}

  # verify the aws cli configuration by displaying a list of aws regions in table format.
  runuser -c "PATH=/home/${user_name}/.local/bin:${PATH} aws ec2 describe-regions --output table" - ${user_name}
fi

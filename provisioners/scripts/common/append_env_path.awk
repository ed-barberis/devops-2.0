{
  # insert application environment variables here.
  if ($0 ~ /# define prompt code/) {
    printf "# set %s home path.\n", env_comment
    printf "%s=%s\n", env_name, env_value
    printf "export %s\n", env_name
    print ""
    print $0
  }
  # append just prior to $PATH.
  else if (/\$PATH$/) {
    printf "%s$%s/bin%s\n", substr($0, 1, length($0)-5), env_name, substr($0, length($0)-5)
  }
  else {
    print $0
  }
}

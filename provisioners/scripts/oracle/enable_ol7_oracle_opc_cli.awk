{
  if ($0 ~ /# define prompt code/) {
    print "# set oracle public cloud (opc) cli client environment variables."
    printf "OPC_PROFILE_DIRECTORY=%s\n", opc_profile_directory
    print "export OPC_PROFILE_DIRECTORY"
    printf "OPC_PROFILE_FILE=%s\n", opc_profile_file
    print "export OPC_PROFILE_FILE"
    print ""
    print $0
  }
  else {
    print $0
  }
}

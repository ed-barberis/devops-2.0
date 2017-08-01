{
  if ($0 ~ /# define prompt code/) {
    print "# set oracle public cloud (opc) cli client environment variables."
    printf "OPC_API=%s\n", opc_api
    print "export OPC_API"
    printf "OPC_USER=%s\n", opc_user
    print "export OPC_USER"
    print ""
    print $0
  }
  else {
    print $0
  }
}

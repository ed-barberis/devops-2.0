BEGIN {
  uekr4=""
  uekr3=""
  addons=""
}

{
  if ($0 ~ /ol7_UEKR4/) {
    uekr4="1"
    uekr3=""
    addons=""
    print $0
  }
  else if ($0 ~ /ol7_UEKR3/) {
    uekr4=""
    uekr3="1"
    addons=""
    print $0
  }
  else if ($0 ~ /ol7_addons/) {
    uekr4=""
    uekr3=""
    addons="1"
    print $0
  }
  else if ($0 ~ /^$/) {
    uekr4=""
    uekr3=""
    addons=""
    print $0
  }
  else if ($0 ~ /enabled/) {
    if (uekr4) {
      print "enabled=1"
    }
    else if (uekr3) {
      print "enabled=0"
    }
    else if (addons) {
      print "enabled=1"
    }
    else {
      print $0
    }
  }
  else {
    print $0
  } 
}

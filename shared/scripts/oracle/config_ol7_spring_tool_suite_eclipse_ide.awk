BEGIN {
  print "-vm"
  print "/usr/local/java/jdk180/bin/java"
}

{
  if ($0 ~ /-Xms/) {
    print "-Xms1024m"
  }
  else if ($0 ~ /-Xmx/) {
    print "-Xmx2048m"
  }
  else {
    print $0
  }
}

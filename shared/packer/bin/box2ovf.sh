#!/bin/sh
# script to extract ovf files from a vagrant box.

# test input arguments. --------------------------------------------------------
if [ $# -eq 0 ]; then
  echo "Usage: $(basename $0) <box1>.box [ <box2>.box ] [ etc. ]"
  exit 1
fi

for boxfile in "$@"; do
  vmfile="$(basename ${boxfile})"
  vmname="${vmfile%%.*}"

  echo "Processing file: ${boxfile}..."
  tar -xvf ${boxfile}

  ovffile="${vmname}.ovf"
  mv box.ovf ${ovffile}

  echo "Cleaning up..."
  rm -f Vagrantfile metadata.json

  echo "Done."
done

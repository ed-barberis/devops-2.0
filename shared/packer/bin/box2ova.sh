#!/bin/sh
# script to convert a vagrant box to an ova archive for virtualbox.

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

  ovafile="${vmname}.ova"
  ovffile="${vmname}.ovf"
  mffile="${vmname}.mf"
  vmdkfile="$(ls ${vmname}*.vmdk)"

  mv box.ovf ${ovffile}
  rm -f Vagrantfile metadata.json
  echo "SHA256 (${ovffile})= $(sha256sum ${ovffile} | awk '{print $1}')" >> $mffile
  echo "SHA256 (${vmdkfile})= $(sha256sum ${vmdkfile} | awk '{print $1}')" >> $mffile

  echo "Creating file: ${ovafile}..."
  tar -cvf $ovafile $ovffile $mffile $vmdkfile

  echo "Cleaning up..."
  rm -f $ovffile $mffile $vmdkfile

  echo "Done."
done

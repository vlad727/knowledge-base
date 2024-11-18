#!/bin/bash
# string comparison example with  if [[ "$s1" == "$s2" ]]
# examples tar, gz, bz2, xz, zip, pigz
# how to compress xz -d -v filename.tar.xz
# put arg first arg to var with name file
file=$1

# to determine what is the file # sed change "." to space then awk get the last position
file2=$(echo $file | sed 's/\./ /g' | awk -F " " '{print $NF}')

# use case to extract file
case $file2 in
gz )
  echo "Your compressed file has $file2 extension "
  tar -xvzf $file -C .
  echo "Done"
  ;;
bz2)
  echo "Your compressed file has $file2 extension "
  tar -xvjf $file -C .
  echo "Done"
  ;;
xf)
  echo "Your compressed file has $file2 extension "
  tar -xf $file -C .
  echo "Done"
  ;;
esac
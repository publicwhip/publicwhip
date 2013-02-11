#!/bin/bash

usage()
{
cat << EOF
  Usage: $0 options

  This script pushes out code to the various Public Whip sites.

  OPTIONS:
    -h Show this message
    -s Specify the site - staging|live
EOF
}

push()
{
  site=$1
  tmpdir=/tmp
  tarfile="$tmpdir/publicwhip.tar.gz"
  extractdir="$tmpdir/publicwhip"
  #destdir="/home/paul/dev/pw-$site"
  destdir="/home/publicwhip/publicwhip-$site"

  # Check that destination directory exists before we do anything else
  if [ ! -d "$destdir" ]; then
    echo "Destination directory ($destdir) does not exist"
    exit 1
  fi

  # Download latest source - automatically overwrite an existing copy
  wget https://github.com/publicwhip/publicwhip/tarball/master -O $tarfile

  # Check that tar file was downloaded (should probably check md5sum too)
  if [ ! -e "$tarfile" ]; then
    echo "Failed to download file"
    exit 1
  fi

  # Create extraction directory if it does not already exist
  if [ ! -d "$extractdir" ]; then
    mkdir "$extractdir"
  fi

  # Extract file: use --strip-components to remove the first part of path
  tar xzvf "$tarfile" -C "$extractdir/" --strip-components=1

  # Recursively copy all files - skip files beginning with '.' in root dir
  cp -rv "$extractdir/"* "$destdir"
}

while getopts "s:" option
do
  case $option in
    h)
      usage
      exit
      ;;
    s)
      site=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [[ -z $site ]]
then
  usage
  exit 1
fi

case $site in
  staging)
    push "staging"
    ;;
  live)
    push "live"
    ;;
  ?)
    echo "Invalid site specified"
    exit 1
    ;;
esac


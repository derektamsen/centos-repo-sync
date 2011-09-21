#!/bin/bash

# Distrobution information used to build rsync destination path
OS="centos"
MAJORVER="6"
MINORVER="0"
ARCH="x86_64"

# Standard stuff to define rsync options
# rsync path
RSYNCCMD="/usr/bin/rsync"
# rsync options/flags
RSYNCOPTS="-avSHP"
# rsync source
# OS
OSSOURCE="rsync://mirror.chpc.utah.edu/pub/$OS/$MAJORVER.$MINORVER/os/$ARCH/"
# Updates
UPSOURCE="rsync://mirror.chpc.utah.edu/pub/$OS/$MAJORVER.$MINORVER/updates/$ARCH/"
# rsync destination
# OS
OSDEST="/var/www/html/repo/$OS/$MAJORVER.$MINORVER/$ARCH/base-trunk/"
# Updates
UPDEST="/var/www/html/repo/$OS/$MAJORVER.$MINORVER/$ARCH/updates-trunk/"

# Grab a copy of the os for repo
echo "syncing os to local repo"
$RSYNCCMD $RSYNCOPTS $OSSOURCE $OSDEST
# Grap a copy of the updates for repo
echo "syncing updates to local repo"
$RSYNCCMD $RSYNCOPTS $UPSOURCE $UPDEST
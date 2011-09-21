#!/bin/bash

# Grabs command line parameters for linking files
for i in $*
do
    case $i in
        --repo=* | -r=*)
        # Which repo do you want to edit? Usually base, updates, extras, etc
        REPO=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        --source=* | -s=*)
        # What source do you want to use as your snapshot? (trunk, staging, prod)
        SRC=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        # What is the destination? (trunk, staging, prod)
        --destination=* | -d=*)
        DEST=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        *)
        # unknown option
        echo "Please specify: $0 --repo=<base,updates,extras> --source=<trunk,stage,prod> --destination=<trunk,stage,prod>"
        exit 1
        ;;
    esac
done

# Define some version and os info so we can later construct the path
OS="centos"
MAJORVER="6"
MINORVER="0"
ARCH="x86_64"

# Base path to where you are storing the repo. Typically this is an http site.
BASEPATH="/var/www/html/repo"

# Generates the path where packages and repo files get stored using os, version, and architecture.
LOCALREPOPATH="$BASEPATH/$OS/$MAJORVER.$MINORVER/$ARCH"



echo "Starting snapshot of $REPO-$SRC to $REPO-$DEST"
# Generates the linked repo to create snapshoted branches
# cleans the current destination repo so we have a clean place
echo "Cleaning $LOCALREPOPATH/$REPO-$DEST/ to prep for linking"
rm -rf "$LOCALREPOPATH/$REPO-$DEST/*"

# creates hard links from source repo to destination repo. Saves space as well so you can have a lot of branches
echo "creating snapshot of $LOCALREPOPATH/$REPO-$SRC/* to $LOCALREPOPATH/$REPO-$DEST/ with hard links"
cp -alvf "$LOCALREPOPATH/$REPO-$SRC/*" "$LOCALREPOPATH/$REPO-$DEST/"

# removes the repomod stuff so we can ensure that does not get overwritten by another branch
echo "removing links to repomod stuff"
rm -rf "$LOCALREPOPATH/$REPO-$DEST/repodata/*"

# copyies the repomod stuff so we can hold the db for the linked files.
echo "copying repomod stuff into $LOCALREPOPATH/$REPO-$DEST/"
cp -avf "$LOCALREPOPATH/$REPO-$SRC/repodata" "$LOCALREPOPATH/$REPO-$DEST/"

echo "snapshoting $REPO-$SRC to $REPO-$DEST completed"

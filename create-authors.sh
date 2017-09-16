#!/bin/sh

AUTHORS_FILE=$1
if [ -z "$AUTHORS_FILE" ]; then
    AUTHORS_FILE=authors-transform.txt
fi

SVN_REMOTE_REPO=$2
if [ -z "$SVN_REMOTE_REPO" ]; then
    SVN_REMOTE_REPO=https://scm.wald.intevation.org/svn/openvas
fi

svn log -q $SVN_REMOTE_REPO | \
awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | \
sort -u > $AUTHORS_FILE

#!/bin/sh


MODULE=$1
if [ -z "$MODULE" ]; then
    exit 1
fi

SVN_URL=$2
if [ -z "$SVN_URL" ]; then
    SVN_URL=https://scm.wald.intevation.org/svn/openvas/tags
fi

svn list "$SVN_URL" | grep "^$MODULE" | tr -d '/' | tr '\n' ',' | sed 's/,$/\n/'

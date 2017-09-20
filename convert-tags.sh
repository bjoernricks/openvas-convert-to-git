#!/bin/sh

git for-each-ref --format='%(refname)' refs/heads/tags |
cut -d / -f 4 |
while read ref
do
  SHORT=`echo $ref | sed 's/[a-z]\+-.*-\([0-9].\+\)/\1/'`
  git tag "v$SHORT" "refs/heads/tags/$ref";
  git branch -D "tags/$ref";
done

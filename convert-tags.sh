#!/bin/sh

git for-each-ref --format='%(refname)' refs/remotes/svn/tags |
cut -d / -f 5 |
while read ref
do
  git tag "$ref" "refs/remotes/svn/tags/$ref";
  git branch -r -D "svn/tags/$ref";
done

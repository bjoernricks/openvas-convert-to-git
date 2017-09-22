#!/bin/sh

echo "Deleting tags with @"

git for-each-ref --format='%(refname)' refs/tags |
cut -d / -f 3 |
while read ref
do
    SHORT=`echo $ref | grep @`

    if [ -n "$SHORT" ]; then
        if [ -n "$1" ]; then
            echo "found $ref"
        else
            git tag -d $ref
        fi
    fi
done

echo "Deleting branches with @"

git for-each-ref --format='%(refname)' refs/heads |
cut -d / -f 3 |
while read ref
do
    SHORT=`echo $ref | grep @`

    if [ -n "$SHORT" ]; then
        if [ -n "$1" ]; then
            echo "found $ref"
        else
            git branch -D $ref
        fi
    fi
done

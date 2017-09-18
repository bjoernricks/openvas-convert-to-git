#!/bin/sh

set -e

CONFIG=$1
if [ -z "$CONFIG" ]; then
    echo "Please specifiy a config"
    exit 1
fi

. "$(realpath "$CONFIG")"

if [ -z "$GIT_REPO_PATH" ]; then
    echo "Config missing GIT_REPO_PATH variable"
    exit 1
else
    GIT_REPO_PATH=$(realpath "$GIT_REPO_PATH")
fi

if [ -z "$GIT_BARE_REPO_PATH" ]; then
    GIT_BARE_REPO_PATH="$GIT_REPO_PATH.git"
else
    GIT_BARE_REPO_PATH=$(realpath "$GIT_BARE_REPO_PATH")
fi

CONVERT_REPO=$(realpath "$0")
CONVERT_REPO=$(dirname "$CONVERT_REPO")

if [ ! -d "$GIT_REPO_PATH" ]; then
    echo "Missing git repo at $GIT_REPO_PATH. Please run $CONVERT_REPO/init.sh."
    exit 1
fi

cd "$GIT_REPO_PATH"

echo "Fetching svn data"
git config svn-remote.svn.noMetadata true
git svn fetch

echo "Converting svn-ignore to .gitignore"
$CONVERT_REPO/convert-ignore.sh

git remote add bare "$GIT_BARE_REPO_PATH"
git config remote.bare.push 'refs/remotes/svn/*:refs/heads/*'

echo "Initalizing git bare repository"
git init --bare "$GIT_BARE_REPO_PATH"
cd "$GIT_BARE_REPO_PATH"

git symbolic-ref HEAD refs/heads/trunk

cd "$GIT_REPO_PATH"
git push bare

cd "$GIT_BARE_REPO_PATH"

echo "Converting svn tags to git tags"
$CONVERT_REPO/convert-tags.sh

echo "Renaming trunk to master"
git branch -m trunk master

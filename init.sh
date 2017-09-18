#!/bin/sh

set -e

CONFIG=$1
if [ -z "$CONFIG" ]; then
    echo "Please specifiy a config"
    exit 1
fi

. "$(realpath "$CONFIG")"

if [ -z "$MODULE" ]; then
    echo "Config missing MODULE variable"
    exit 1
fi
if [ -z "$USERNAME" ]; then
    echo "Config missing USERNAME variable"
    exit 1
fi
if [ -z "$GIT_REPO_PATH" ]; then
    echo "Config missing GIT_REPO_PATH variable"
    exit 1
fi

CONVERT_REPO=$(realpath "$0")
CONVERT_REPO=$(dirname "$CONVERT_REPO")

SVN_REMOTE_URL="https://scm.wald.intevation.org/svn/openvas"
SVN_PUSH_URL="svn+ssh://$USERNAME@scm.wald.intevation.org/openvas"

mkdir -p "$GIT_REPO_PATH"
cd "$GIT_REPO_PATH"
git init

if [ -z "$TRANSFORM_FILE" ]; then
    TRANSFORM_FILE="authors-transform-$MODULE.txt"
    "$CONVERT_REPO"/create-authors.sh "$TRANSFORM_FILE" "$SVN_REMOTE_URL"
fi

git config svn.authorsfile "$TRANSFORM_FILE"
git config svn-remote.svn.url "$SVN_PUSH_URL"
git config svn-remote.svn.fetch "trunk/$MODULE:refs/remotes/svn/trunk"

if [ -z "$BRANCHES_MODULE" ]; then
    echo "Config missing BRANCHES_MODULE variable. Skipping branches."
else
    BRANCHES=$("$CONVERT_REPO"/list-branches.sh "$BRANCHES_MODULE" "$SVN_REMOTE_URL/branches")
    git config svn-remote.svn.branches "branches/{$BRANCHES}:refs/remotes/svn/*"
fi


if [ -z "$TAGS_MODULE" ]; then
    echo "Config missing TAGS_MODULE variable. Skipping tags."
else
    TAGS=$("$CONVERT_REPO"/list-tags.sh "$TAGS_MODULE" "$SVN_REMOTE_URL/tags")
    git config svn-remote.svn.tags "tags/{$TAGS}:refs/remotes/svn/tags/*"
fi

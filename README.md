# Scripts to convert OpenVAS SVN repos to git

The available scripts are using git-svn for converting the svn repositories to
git. This procedure doesn't require file access to the svn server. To install
git-svn on Debian based systems run

```
apt-get install git-svn
```

## Steps to convert an OpenVAS module to a git repository

### 1. Create a new config

  ```sh
  $EDITOR <config file>
  ```

  Add the following variables to the config file

  ```sh
  USERNAME=<username for svn repo access>
  MODULE=<module name e.g. openvas-manager>
  TAGS_MODULE=$MODULE # name may be different from $MODULE
  BRANCHES_MODULE=$MODULE # name may be different from $MODULE
  GIT_REPO_PATH=<path to created git repo> # e.g /path/to/manager-git
  ```

### 2. Run init script

  ```
  /path/to/convert-repo/init.sh /path/to/<config file>
  ```

### 3. Update created authors file

  If you are not already using an existing authors transform file the svn
  user names should be mapped to real names.

  ```sh
  cd <path to created git repo>
  $EDITOR authors-transform-<module name>.txt
  ```

### 4. Check and adjust generated git config

  Check the generated settings at the git config for svn tags and branches. It
  is possible to user wildcards for branches and tags instead to list all. Also
  you may add several branches and tags variables.

  ```sh
  cd <path to created git repo>
  $EDITOR .git/config
  ```

### 5. Run

  ```sh
  /path/to/convert-repo/convert.sh /path/to/<config file>
  ```

### 6. Finished

  Afterwards you will get to repos `$GIT_REPO_PATH` and `$GIT_REPO_PATH.git`
  The `$GIT_REPO_PATH.git` path contains a bare repository that can be used as a
  master.

### 7. Optional cleanup

  Sometimes git-svn creates xyz@revsion tags and branches during conversion. You
  can delete those branches and tags.

  ```sh
  source <path to config file>
  cd $GIT_REPO_PATH.git
  /path/to/convert-repo/delete-at.refs.sh
  ```

  Also some older branches may use `-` in their version. These branches should
  be renamed.
  ```sh
  git branch -m <name>-<x>-<y> <name>-<x>.<y>
  ```

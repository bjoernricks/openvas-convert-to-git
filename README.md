# Scripts to convert OpenVAS SVN repos to git


## Steps to convert an OpenVAS module to a git repository

1. Create a new config

  ```sh
  $EDITOR <config file>
  ```

  Add the following variables to the config file

  ```sh
  USERNAME=<username for svn repo access>
  MODULE=<module name e.g. openvas-manager>
  TAGS_MODULE=$MODULE # name may be different from $MODULE
  BRANCH_MODUE=$MODULE # name may be different from $MODULE
  GIT_REPO_PATH=<path to created git repo> # e.g /path/to/manager-git
  ```

2. Run init script

  ```
  $ /path/to/convert-repo/init.sh /path/to/<config file>
  ```

3. Update created authors file

  ```sh
  cd <path to created git repo>
  $EDITOR authors-transform-<module name>.txt
  ```

4. Convert svn repo by fetching commits

  ```sh
  cd <path to created git repo>
  git svn fetch
  ```

5. Create a .gitignore file from svnignore

  ```sh
  cd <path to created git repo>
  git svn show-ignore > .gitignore
  ```

6. Convert tags to git tags

  svn tags are fetched as git branches. Now convert them to real git tags

  ```sh
  cd <path to created git repo>
  /path/to/convert-repo/convert-tags.sh
  ```

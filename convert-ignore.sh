#!/bin/sh
git svn show-ignore > .gitignore
git add .gitignore
git commit -m "Convert svn:ignore properties to .gitignore file"

#!/bin/sh

base_branch=$1
if [ -z $base_branch ] ; then
  echo 'usage: git-delete-merged-branches-with-remote [base_branch]' >&2
  exit 1
fi

git show-ref --verify --quiet refs/heads/$base_branch
if [ $? -ne 0 ] ; then
  echo "error: base branch '$base_branch' not found" >&2
  exit 1
fi

git branch --merged $base_branch | xargs -n 1 | grep -Ev "^(\*|$base_branch)$" | xargs -n 1 git branch -d

git fetch --prune

git branch -r --merged $base_branch | grep -v ' -> ' | sed 's/\([^\/]*\)\/\(.*\)/\1 :\2/' | grep -v ":$base_branch$" | xargs -n 2 -Itarget git push target 2>/dev/null


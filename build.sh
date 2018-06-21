#! /bin/bash
# The purpose of this shell script is mainly building the static comments.

# Exit on any error
set -e

echo "Set git credentials."
git config --global user.email "hsnfirooz@yahoo.com"
git config --global user.name "hsnfirooz"
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials

echo "Install python deps for building comments."
pip install requests pyyaml cryptography langdetect pathlib2

echo "Build static comments if there are any."
python rebuild_comments.py

# Disable exiting on errors automatically
set +e

#git checkout $BRANCH
#git pull origin $BRANCH

git add ./_source/_data/comments
git commit --message "Netlify - Update static comments." > /dev/null

if [ $? -eq 0 ]; then
  echo "Pushing new comments."
  #git remote add origin2 https://github.com/mehdisadeghi/mehdix.ir
  #git push origin2 $BRANCH
fi

echo "Building the website."
jekyll build

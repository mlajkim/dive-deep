#!/bin/bash

set -e

BRANCH_DATE=$(LC_TIME=C date "+%b-%d-%Y" | tr '[:upper:]' '[:lower:]') # i.e) dec-24-2025
BRANCH_NAME="${BRANCH_DATE}-daily-dive"

FILE_DATE=$(date "+%y%m%d") # i.e) 251224
FILE_PATH="proofs/meal/${FILE_DATE}.meal.md"

echo "Current Date: $BRANCH_DATE"
echo "Target Branch: $BRANCH_NAME"
echo "Target File: $FILE_PATH"

echo "Checking out main..."
git checkout main
git pull origin main

echo "Creating branch $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME"

cat <<EOF > "$FILE_PATH"
# ${FILE_DATE}

<!-- TOC -->

<!-- /TOC -->

## Breakfast.xxx.xx

## Lunch.xxx.xx

## Dinner.xxx.xx

EOF

echo "File created at $FILE_PATH"

git add "$FILE_PATH"
git commit -m "first automated commit"

git push -u origin "$BRANCH_NAME"

echo "Done! Open the PR: https://github.com/mlajkim/dive-deep/pulls"

#!/bin/bash


# Sample Code
# git checkout main
# git branch -D jan-26-2026-daily-dive
# git push origin --delete jan-26-2026-daily-dive
# git branch -dr origin/jan-26-2026-daily-dive
# then run

set -e

# Variables
BRANCH_DATE=$(LC_TIME=C date "+%b-%d-%Y" | tr '[:upper:]' '[:lower:]')
BRANCH_NAME="${BRANCH_DATE}-daily-dive"
FILE_NEXT_DATE=$(date -v+1d "+%y%m%d")
FILE_DATE=$(date "+%y%m%d")

echo "Current Date: $BRANCH_DATE"
echo "Target Branch: $BRANCH_NAME"

git checkout main
git pull origin main
git fetch origin

if git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME"; then
  echo "🔄 Sync and exit: Branch Already Exists"
  git checkout "$BRANCH_NAME"
  git pull origin "$BRANCH_NAME"
  exit 0
fi

# Create new branch:
echo "🆕 Creating new branch $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME"

# Create _wip.md if it does not exist:
mkdir -p weekly_dives/wip/assets
WIP_PATH="weekly_dives/wip/_wip.md"
if [ ! -f "$WIP_PATH" ]; then
    cat <<-EOF > "$WIP_PATH"
---
title: '🟡 TODO: GIVE ME TITLE'
published: true
tags:
  - 🟡 nodashtag
  - 🟡 onlyfour
  - 🟡 nospace
---
# Goal
> [!TIP]
> In hurry? Jump directly to [Result](#result) section.

TODO: Write goal here.

# Architecture
# Table of Contents
# Result
# Setup
# What I learned
# What's next?
# Dive Hours: XX Hours
# Closing
EOF
fi

# Create TODOs in READMEs:
for readme in README.alcohol.md README.md README.protein.md README.sleep.md \
              README.workout.md README.dishwash.md README.no-electronics-on-bed.md \
              README.weight.md; do
    echo "🟡 TODO" >> "$readme"
done

echo "🟡 TODO: Dive Hours ($(date))" >> "$WIP_PATH"

# Create _raw.${FILE_DATE}.md if it does not exist:
RAW_PATH="weekly_dives/wip/_raw.${FILE_DATE}.md"
if [ ! -f "$RAW_PATH" ]; then
  cat <<-EOF > "$RAW_PATH"
# Goal of _raw.${FILE_DATE}.md
🟡 TODO: Write one goal here.

## Setup: ...
EOF
fi

git add .
git commit -m "$BRANCH_NAME initial setup"
git push -u origin "$BRANCH_NAME"

open "https://github.com/mlajkim/dive-deep/compare/main...$BRANCH_NAME?expand=1"

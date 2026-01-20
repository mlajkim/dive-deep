#!/bin/bash

set -e

BRANCH_DATE=$(LC_TIME=C date "+%b-%d-%Y" | tr '[:upper:]' '[:lower:]') # i.e) dec-24-2025
BRANCH_NAME="${BRANCH_DATE}-daily-dive"

# For meal file, we create for the next day:
FILE_NEXT_DATE=$(date -v+1d "+%y%m%d") # i.e) 251225
FILE_PATH="proofs/meal/${FILE_NEXT_DATE}.meal.md"

echo "Current Date: $BRANCH_DATE"
echo "Target Branch: $BRANCH_NAME"
echo "Target File: $FILE_PATH"

echo "Checking out main..."
git checkout main
git pull origin main

# If branch already exists, checkout and pull and exit:
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo "Branch $BRANCH_NAME already exists. Checking out and pulling..."
    git checkout "$BRANCH_NAME"
    git pull origin "$BRANCH_NAME"
    exit 0
fi

# If not exists, create one and checkout:
echo "Creating branch $BRANCH_NAME..."
git checkout -b "$BRANCH_NAME"

mkdir -p weekly_dives/wip
WIP_PATH="weekly_dives/wip/_wip.md"
if [ ! -f "$WIP_PATH" ]; then
    cat <<-EOF > "$WIP_PATH"

---
title: '🟡 TODO: GIVE ME TITLE'
published: true
tags: # four tags only, no '-' or special characters except
  - 🟡 nodashtag
  - 🟡 onlyfour
  - 🟡 nospace
---

```sh
# cover_image: ./thumbnail.png # 🟡 give me thumbnail
```

# Goal

> [!TIP]
> In hurry? Jump directly to [Result](#result) section to see the outcome of this dive.

TODO: Write goal here above the line.

# Architecture

# Table of Contents

<!-- TOC -->

<!-- /TOC -->

# Result

# Setup

## Setup: ...

## Setup: ...

## Verify

Please refer to the [Result](#result) section above to see the verification steps and outcome.

# What I learned

# What's next?

# Dive Hours: XX Hours

# Closing



EOF
  echo "WIP file created at $WIP_PATH"
  mkdir -p weekly_dives/wip/assets
else
  echo "WIP file already exists at $WIP_PATH"
fi

# Write TODOs so that you do not forget:

echo "🟡 TODOs:" >> "README.alcohol.md"
echo "🟡 TODOs:" >> "README.md"
echo "🟡 TODOs:" >> "README.protein.md"
echo "🟡 TODOs:" >> "README.sleep.md"
echo "🟡 TODOs:" >> "README.workout.md"
echo "🟡 TODOs:" >> "README.dishwash.md"
echo "🟡 TODOs:" >> "README.no-electronics-on-bed.md"
echo "🟡 TODOs:" >> "README.weight.md"
echo "🟡 TODOs: Dive Hours" >> "./weekly_dives/wip/_wip.md"

# if _raw.XXXXXX.md does not exist in weekly_dives/wip, create it:
FILE_DATE=$(date "+%y%m%d") # i.e) 251224
RAW_PATH="weekly_dives/wip/_raw.${FILE_DATE}.md"
if [ ! -f "$RAW_PATH" ]; then
  cat <<-EOF > "$RAW_PATH"
# Goal of _raw.${FILE_DATE}.md

🟡 TODO: Write one goal here.

<!-- TOC -->

<!-- /TOC -->

## Setup: ...

EOF
fi

# Right after creating/editing files, commit and push:
git add .
git commit -m "$BRANCH_NAME"

git push -u origin "$BRANCH_NAME"

open https://github.com/mlajkim/dive-deep/pulls

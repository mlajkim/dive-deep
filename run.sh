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
<!-- # 251225.2863.132.18 -->

# ${FILE_DATE}

> [!TIP]
> Check out the parent README file: [README.meal.md](../../README.meal.md)

<!-- 414 + 700 + 1180 = 2294 kcal

6 + 14 + 46 = 66 g protein

66g * 4 = 264kcal / 2294kcal = 11% protein -->

<!-- TOC -->

<!-- /TOC -->

<!-- ## Breakfast.627.47 -->

## Breakfast.xxx.xx


|    Food     | Calories | Protein |
|:-----------:|:--------:|:-------:|
|     ...     |   ...    |   ...   |


<!-- ## Lunch.71.12 -->

## Lunch.xxx.xx

|    Food     | Calories | Protein |
|:-----------:|:--------:|:-------:|
|     ...     |   ...    |   ...   |

<!-- ## Dinner.71.12 -->

## Dinner.xxx.xx

|    Food     | Calories | Protein |
|:-----------:|:--------:|:-------:|
|     ...     |   ...    |   ...   |


EOF



echo "File created at $FILE_PATH"

# creates wip directory and wip.md if not exists:

mkdir -p weekly_dives/wip
WIP_PATH="weekly_dives/wip/_wip.md"
if [ ! -f "$WIP_PATH" ]; then
    cat <<EOF > "$WIP_PATH"

---
title: '🟡 TODO: GIVE ME TITLE'
published: true
tags: # four tags only, no '-' or special characters except
  - 🟡 nodashtag
  - 🟡 onlyfour
  - 🟡 nospace
cover_image: ./thumbnail.png # 🟡 give me thumbnail
---

# Goal

TODO: Write goal here above the line.

<!-- TOC -->

- [Goal](#goal)
- [Result](#result)
- [Walkthrough: Setup](#walkthrough-setup)
  - [a.](#a)
- [Walkthrough: Implementation](#walkthrough-implementation)
  - [1.](#1)
- [Walkthrough: Verification](#walkthrough-verification)
  - [I.](#i)
- [What's next?](#whats-next)
- [Dive Hours: XX Hours](#dive-hours-xx-hours)
- [Closing](#closing)

<!-- /TOC -->

# Result

# Walkthrough: Setup

## a.

# Walkthrough: Implementation

## 1.

# Walkthrough: Verification

## I.

# What's next?

# Dive Hours: XX Hours

# Closing



EOF
  echo "WIP file created at $WIP_PATH"
else
  echo "WIP file already exists at $WIP_PATH"
fi

# if _raw.XXXXXX.md does not exist in weekly_dives/wip, create it:
RAW_PATH="weekly_dives/wip/_raw.${FILE_DATE}.md"
if [ ! -f "$RAW_PATH" ]; then
  touch "$RAW_PATH"
fi

git add "$FILE_PATH"
git commit -m "$BRANCH_NAME"

git push -u origin "$BRANCH_NAME"

open https://github.com/mlajkim/dive-deep/pulls

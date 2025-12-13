# diff


<!-- TOC -->

- [diff](#diff)
  - [Setup](#setup)
  - [Understand results](#understand-results)

<!-- /TOC -->

## Setup

Setup:
```sh
test_name=diff_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir && cd ~/test_dive/$tmp_dir

cat > file.txt <<EOF
canada
canada
canada
canada
EOF

cat > file_v2.txt <<EOF
canada
Canada
canada
usa
EOF

```

## Understand results

Basically the diff is a tool to make two files the same by showing the differences:
- `a`: add
- `d`: delete
- `c`: change

- If it says `3a4`, it means after adding the 3rd line in the left, 4th line in the right appears.
  - It says `3a4,5`, it means after adding the 3rd line in the left, 4th and 5th lines in the right appear.
- If it says `18d17`, it means delete the 18th line, and the 17th line in the right remains.
- If it says `5c5`, it means change the 5th line in the left to the 5th line in the right.




Run diff between two files:

```sh
diff file.txt file_v2.txt
# 1a2
# > Canada
# 3,4c4
# < canada
# < canada
# ---
# > usa
```

Search with context option `-c`:

```sh
diff -c file.txt file_v2.txt
# *** file.txt	Fri Dec  5 12:37:26 2025
# --- file_v2.txt	Fri Dec  5 12:37:26 2025
# ***************
# *** 1,4 ****
#   canada
#   canada
# ! canada
# ! canada
# --- 1,4 ----
#   canada
# + Canada
#   canada
# ! usa
```

Search with side by side option `-y`:

```sh
diff -y file.txt file_v2.txt
# canada									canada
# 								>       Canada
# canada									canada
# canada								|       usa
# canada								<
```

Search with case insensitive option `-i`:

```sh
diff -iy file.txt file_v2.txt
# canada								canada
# canada								Canada
# canada								canada
# canada							      |	usa
```


# diff


<!-- TOC -->

- [diff](#diff)
  - [Setup](#setup)
  - [Test](#test)

<!-- /TOC -->

## Setup

Setup:
```sh
test_name=diff_command
tmp_date=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_date

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

## Test

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


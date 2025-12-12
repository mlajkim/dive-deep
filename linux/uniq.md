# uniq

<!-- TOC -->

- [uniq](#uniq)
  - [Setup](#setup)
  - [Unique names only](#unique-names-only)

<!-- /TOC -->

## Setup

```sh
test_name=test
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir && cd ~/test_dive/$tmp_dir
echo -e "john uk\namy korea\nmichael usa\nsara canada\njohn uk" > file.txt
cat file.txt
# john uk
# amy korea
# michael usa
# sara canada
# john uk
```

## Unique names only

Please check out the [[cut]] command to get only names first.

Why john appears twice? Because `uniq` only removes *consecutive* duplicate lines:

```sh
cut -d ' ' -f 1 file.txt | uniq
# john
# amy
# michael
# sara
# john
```

If you want to remove all duplicates, you need to sort the input first using the [[sort]] command:
```sh
cut -d ' ' -f 1 file.txt | sort | uniq
# amy
# john
# michael
# sara
```
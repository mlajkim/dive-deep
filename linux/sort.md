



Setup:
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

## Sort

You may [[cut]] the names first, then [[uniq]] them, and finally sort them:

```sh
cut -d ' ' -f 1 file.txt | uniq | sort
# amy
# john
# michael
# sara
```
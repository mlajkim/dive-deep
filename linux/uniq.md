# uniq





Setup:
```sh
tmp_date=$(date +%y%m%d_%H%M%S_test)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_date
echo -e "john uk\namy korea\nmichael usa\nsara canada\njohn uk" > file.txt
cat file.txt
# john uk
# amy korea
# michael usa
# sara canada
# john uk
```

## Unqiue names only

Please check out the [[cut]] command to get only names first.

```sh
cut -d ' ' -f 1 file.txt | uniq
# john
# amy
# michael
# sara
```
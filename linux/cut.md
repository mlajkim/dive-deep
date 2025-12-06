# cut


Setup:
```sh
test_name=test
tmp_date=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_date
echo -e "john uk\namy korea\nmichael usa\nsara canada\njohn uk" > file.txt
cat file.txt
# john uk
# amy korea
# michael usa
# sara canada
# john uk
```

### Get names only (third column)

> [!NOTE]
> You may [[uniq]] or [[sort]] the names after this.

- `d`: delimiter
- `f`: field (not 0-indexed, starts from 1)

```sh
cut -d ' ' -f 1 file.txt
# john
# amy
# michael
# sara
# john
```

And again, it does not modify the original file (you may do `>` to redirect output to a new file):

```sh
cat file.txt
# john uk
# amy korea
# michael usa
# sara canada
# john uk
```




# cut


Setup:
```sh
tmp_date=$(date +%y%m%d_%H%M%S_test)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_date
echo -e "canada cada john\ncanada cada amy\ncada cada michael\ncada cada sara" > file.txt
cat file.txt
# canada cada john
# canada cada amy
# cada cada michael
# cada cada sara
```

### Get names only (third column)

- `d`: delimiter
- `f`: field (not 0-indexed, starts from 1)

```sh
cut -d ' ' -f 3 file.txt
# john
# amy
# michael
# sara
```

And again, it does not modify the original file:

```sh
cat file.txt
# canada cada john
# canada cada amy
# cada cada michael
# cada cada sara
```

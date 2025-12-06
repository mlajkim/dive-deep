# sed

**s**tream **ed**itor

<!-- TOC -->

- [sed](#sed)
  - [Setup](#setup)
  - [Replace string without changes](#replace-string-without-changes)
  - [Actually modify file using -i](#actually-modify-file-using--i)

<!-- /TOC -->


## Setup

```sh
tmp_date=$(date +%y%m%d_%H%M%S_test)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_date
echo -e "canada cada\ncanada cada\ncada cada\ncada cada" > file.txt
cat file.txt
# canada cada
# canada cada
# cada cada
# cada cada
```

## Replace string without changes
Here is the setting:
- `s`: substitute
- `g`: global (applies for every occurrence in the line)
- without `g`: applies only for the first occurrence in the line (Still loops through lines)

```sh
sed 's/cada/canada/g' file.txt
# canada canada
# canada canada
# canada canada
# canada canada
```

So you may apply only the first one:
```sh
sed 's/cada/canada/' file.txt
# canada canada
# canada canada
# canada cada
# canada cada
```

Note that the `sed` above does not modify the original file:

```sh
cat file.txt
# canada cada
# canada cada
# cada cada
# cada cada
```


To modify the original file, use `-i` option:

## Actually modify file using -i

>[!WARNING]
> It is important to always make a backup of your original file before using the `-i` option with `sed`, as this option modifies the file in place and the changes cannot be undone.

```sh
sed -i .bak 's/cada/canada/g' file.txt
cat file.txt
# canada canada
# canada canada
# canada canada
# canada canada
```

with `-i .bak`, a backup file `file.txt.bak` is created:

```sh
cat file.txt.bak
# canada cada
# canada cada
# cada cada
# cada cada
```





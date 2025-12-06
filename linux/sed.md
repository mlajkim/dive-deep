# sed

**s**tream **ed**itor

<!-- TOC -->

- [sed](#sed)
  - [Setup](#setup)
  - [Replace string without changes](#replace-string-without-changes)
    - [Replace with line numbers](#replace-with-line-numbers)
    - [Escape with custom delimiter](#escape-with-custom-delimiter)
  - [Delete lines](#delete-lines)
  - [Finally: Actually modify file using -i](#finally-actually-modify-file-using--i)

<!-- /TOC -->


## Setup

```sh
test_name=test
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_dir
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

> [!WARNING]
> Please do not get confused with `-i` and `/gi/` options. They are different.

Here is the setting for the end of it:
- `g`: global (applies for every occurrence in the line)
- `gi`: global & case insensitive
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

### Replace with line numbers

You can also specify line numbers to apply the substitution only to specific lines. For example, to replace "cada" with "canada" only on lines 2 and 4:

```sh
sed '2,4s/cada/canada/g' file.txt
# canada cada
# canada canada
# cada cada
# canada canada
```


### Escape with custom delimiter

Sometimes you want to replace strings that contain `/`. That case you can define your own delimiter, e.g., `|`:

```sh
sed 's|cada|canada|g' file.txt
# canada canada
# canada canada
# canada canada
# canada canada
```

## Delete lines

```sh
sed '1,2d' file.txt  # Delete lines from 1 to 2
```

## Finally: Actually modify file using -i

Note that the `sed` above does not modify the original file:

```sh
cat file.txt
# canada cada
# canada cada
# cada cada
# cada cada
```

To modify the original file, use `-i` option:

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





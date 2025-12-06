# grep

> ![NOTE]
> grep is to search texts. If you want to search files instead, please check out [[find]] command.

<!-- TOC -->

- [grep](#grep)
  - [Basic Grep](#basic-grep)
    - [Exclude lines matching a pattern using `-v` flag](#exclude-lines-matching-a-pattern-using--v-flag)
    - [-w flag: Match whole words only](#-w-flag-match-whole-words-only)
    - [-o flag: Print only matching parts of a line](#-o-flag-print-only-matching-parts-of-a-line)
    - [Search file contents recursively -r](#search-file-contents-recursively--r)
    - [Regex mode](#regex-mode)

<!-- /TOC -->

`Grep` basically uses the [[regexp]] (regular expression) patterns to search texts.


## Basic Grep

Setup:
```sh
test_name=grep_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_date && cd ~/test_dive/$tmp_dir

cat > file.txt <<EOF
pattern
non_pattern
non-pattern
nonpattern
pattern
totally different line
EOF
```


### Exclude lines matching a pattern using `-v` flag

```sh
grep -v 'pattern' file.txt
# totally different line
```


### -w flag: Match whole words only

That `-` is included with `-w` flag:

```sh
grep -w 'pattern' file.txt
# pattern
# non-pattern
# pattern
```

### -o flag: Print only matching parts of a line

```sh
grep -o 'pattern' file.txt  # Print only matching parts of a line
# pattern
# pattern
# pattern
# pattern
# pattern
```

### Search file contents recursively -r

Search through files recursively `-r` for the case-insensitive `-i` word "password" in `/etc/` directory:
```sh
grep -ir 'password' /etc/
```

### Regex mode

> [!NOTE]
> By default `grep` uses basic regular expressions. To use newer regex features, use `grep -E` or `egrep`.


```sh
grep -Er '0+' /etc/
egrep -r '0+' /etc/
```


### Name

```sh
find -name *cert*
# case insensitive:
find -iname *cert*
```

### Permission

```sh
find -perm /4000
find -perm /2000
```

### Size

```sh
find -size +50M
```


### Modified Time

modified minute:

```sh
find -mmin -30
```

```sh
find . -mtime -7
```
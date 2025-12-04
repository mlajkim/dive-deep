

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
find -size +50c
find -size +50k
find -size +50M
find -size +50G
```


### Modified Time

Logically speaing, the modifed time cannot be future time,

> [!NOTE]
> Difference between modified and change in Linux is as below:
- atime: access time
- mtime: modified time: when you change the content of file. note that ctime also modifes with modified time (due to size, etc)
- ctime: change time: when you change the inode data (metadata) of file

```sh
find -mmin -30
# 30 minutes or older ones:
find -mmin +30
find -mtime +30
```
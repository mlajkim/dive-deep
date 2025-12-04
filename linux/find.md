# Find

<!-- TOC -->

- [Find](#find)
  - [Based on ...](#based-on-)
    - [Name](#name)
    - [Permission](#permission)
    - [Size](#size)
    - [Modified Time](#modified-time)

<!-- /TOC -->

## Based on ...

Please noe that you can have multiple params together to filter down the results.
To use logical OR, use `-o` between the conditions:


```sh
find -name "*cert*" -o -size +50M
```

### Name

```sh
find -name *cert*
# case insensitive:
find -iname *cert*
```

### Permission

```sh
find -perm 644
# at least 644 permission file:
find -perm -644
# at most 644 permission file:
find -perm +644
# / means any permission:
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

Logically speaking, the modifed time cannot be future time,

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
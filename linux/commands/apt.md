# apt

<!-- TOC -->

- [apt](#apt)
  - [overview](#overview)
    - [Default repository: /etc/apt/sources.list](#default-repository-etcaptsourceslist)
  - [apt update](#apt-update)
    - [apt upgrade](#apt-upgrade)
    - [apt install <package_name>](#apt-install-package_name)
    - [dkpg --listfiles <package_name>](#dkpg---listfiles-package_name)
    - [dkpg --listfiles <package_name>](#dkpg---listfiles-package_name-1)
    - [apt show <package_name>](#apt-show-package_name)
    - [apt remove <package_name>](#apt-remove-package_name)
      - [apt autoremove <package_name>](#apt-autoremove-package_name)

<!-- /TOC -->

## overview


### Default repository: /etc/apt/sources.list

```sh
cat /etc/apt/sources.list
```

## apt update

This only syncs the database of available packages and their versions, but it does not install or upgrade any packages.

### apt upgrade

This actually downloads.

### apt install <package_name>

### dkpg --listfiles <package_name>


### dkpg --listfiles <package_name>

### apt show <package_name>

### apt remove <package_name>

#### apt autoremove <package_name>

To delete dependencies that were installed with the package and are no longer needed.



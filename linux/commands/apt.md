# apt

<!-- TOC -->

- [apt](#apt)
  - [overview](#overview)
    - [cat /etc/apt/sources.list: Default repository](#cat-etcaptsourceslist-default-repository)
    - [apt update](#apt-update)
    - [apt search](#apt-search)
    - [apt upgrade](#apt-upgrade)
    - [apt install <package_name>](#apt-install-package_name)
    - [dpkg --search <path>](#dpkg---search-path)
    - [dkpg --listfiles <package_name>](#dkpg---listfiles-package_name)
    - [apt show <package_name>](#apt-show-package_name)
    - [apt remove <package_name>](#apt-remove-package_name)
      - [apt autoremove <package_name>](#apt-autoremove-package_name)
  - [gpg -dearmor <downloaded_key> && mv /etc/apt/keyrings/](#gpg--dearmor-downloaded_key--mv-etcaptkeyrings)
  - [add-app-repository ppa:<repository_name>](#add-app-repository-pparepository_name)
    - [add-app-repository --remove ppa:<repository_name>](#add-app-repository---remove-pparepository_name)

<!-- /TOC -->

## overview


### cat /etc/apt/sources.list: Default repository

```sh
cat /etc/apt/sources.list
```


Suites:

- `noble`: main repository
- `noble-updates`: regular updates
- `noble-backports`: packages not tested enough, but the latest
- `noble-security`: security updates (CVE)



### apt update

> [!TIP]
> Note that Ubuntu has this name `jammy` or `noble`

This only syncs the database of available packages and their versions, but it does not install or upgrade any packages.

### apt search
```sh
apt search apache http server
# Sorting... Done
# Full Text Search... Done
# apache2/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server

# apache2-bin/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server (modules and other binary files)

# apache2-data/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 all
#   Apache HTTP Server (common files)

# apache2-dev/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server (development headers)

# apache2-doc/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 all
#   Apache HTTP Server (on-site documentation)

# apache2-ssl-dev/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server (mod_ssl development headers)

# apache2-suexec-custom/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server configurable suexec program for mod_suexec

# apache2-suexec-pristine/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server standard suexec program for mod_suexec

# apache2-utils/jammy-updates,jammy-security 2.4.52-1ubuntu4.16 amd64
#   Apache HTTP Server (utility programs for web servers)

# libapache2-mod-svn/jammy-updates,jammy-security 1.14.1-3ubuntu0.22.04.1 amd64
#   Apache Subversion server modules for Apache httpd

# open-infrastructure-apache-tools/jammy 20220105-1 all
#   additional tools for Apache HTTP server
```

### apt upgrade

This actually downloads.

### apt install <package_name>

### dpkg --search <path>

`dpkg`: Debian package manager

```sh
dpkg --search /bin/ls
coreutils: /bin/ls
```

### dkpg --listfiles <package_name>

```sh
dpkg --listfiles coreutils | grep ^/bin
# /bin
# /bin/cat
# /bin/chgrp
# /bin/chmod
# /bin/chown
# /bin/cp
# /bin/date
# /bin/dd
# /bin/df
```

### apt show <package_name>

### apt remove <package_name>

#### apt autoremove <package_name>

To delete dependencies that were installed with the package and are no longer needed.


## gpg -dearmor <downloaded_key> && mv /etc/apt/keyrings/

GNU Privacy Guard

- `keyrings`:


## add-app-repository ppa:<repository_name>

### add-app-repository --remove ppa:<repository_name>
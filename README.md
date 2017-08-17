Build cross compile for Zaurus on Docker.

# Usage

## Create Docker image

```bash
$ docker build ./ -t zaurus-dev
```

## Create Docker contena

```bash
$ docker run -it zaurus-dev /bin/bash
```



# Build zlib

## Download file and uncompressed

```bash
$ mkdir -p src/zlib
$ cd src/zlib
$ wget https://zlib.net/zlib-1.2.11.tar.gz
$ tar zxf zlib-1.2.11.tar.gz
```


## Create ipk directory
ipk is Zaurus package file.

```bash
$ mkdir -p ipk/opt/QtPalmtop
$ mkdir ipk/CONTROL
```


## Build
You should use /opt/QtPalmtop directory.

```bash
$ cd zlib-1.2.11
$ ./configure --prefix=/home/zaurus/src/zlib/ipk/opt/QtPalmtop
$ make
$ make install
```


## Create ipk package

```bash
$ cd ../
$ vi ipk/CONTROL/control
```

Write package details in "control" file.
```
Package: zlib
Priority: optional
Section: libs
Version: 1.2.11
Architecture: arm
Maintainer: kkimigawa
Depends:
Description: zlib is compression library.
```

Create ipk file.
```bash
$ ipkg-build ipk
```

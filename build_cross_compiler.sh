#!/bin/bash

sudo apt update
sudo apt install bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

# install in parallel
git clone --branch gdb-11.1-release git://sourceware.org/git/binutils-gdb.git &

PID=$!

git clone --branch releases/gcc-11.2.0 git://gcc.gnu.org/git/gcc.git
wait $PID

PREFIX="$HOME/opt/cross"
TARGET=i686-elf
PATH="$PREFIX/bin:$PATH"

SRC="$HOME/repos/osdev_utils"
cd $SRC

# make binutils
mkdir build-binutils
cd build-binutils
../binutils-gdb/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make && make install

# make the cross compiler
cd $SRC
mkdir build-gcc
cd build-gcc
../gcc/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc && make all-target-libgcc && make install-gcc && make install-target-libgcc

echo "$HOME/opt/cross/bin/$TARGET-gcc --version"

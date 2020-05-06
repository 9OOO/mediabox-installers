#!/bin/sh

# Mosh/protobuf install by Xan#7777
# Adapted from https://gist.github.com/lazywei/12bc1669dc7739dccef1

# Create temp folder
mkdir "$HOME"/.mosh-tmp
cd "$HOME"/.mosh-tmp || exit

mkdir build
mkdir install

# Download binaries
cd build || exit
curl -O https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip
curl -O https://mosh.org/mosh-1.3.2.tar.gz
unzip protoc-3.11.4-linux-x86_64.zip
tar zxvf mosh-1.3.2.tar.gz

cd "$HOME"/build/protoc-3.11.4-linux-x86_64 || exit
./configure --prefix=$HOME/local --disable-shared
make install

cd $HOME/build/mosh-1.2.4
export PROTOC=$HOME/local/bin/protoc
export protobuf_CFLAGS=-I$HOME/local/include
export protobuf_LIBS=$HOME/local/lib/libprotobuf.a

./configure --prefix=$HOME/local
make install
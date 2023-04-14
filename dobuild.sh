#!/bin/bash


#https://stackoverflow.com/questions/26812060/cross-compile-to-static-lib-libgcrypt-for-use-on-ios


OPT_FLAGS="-O3 -g3"
MAKE_JOBS=8

dobuild() {
    export CC
    CC=$(xcrun --find --sdk "${SDK}" gcc)
    export CXX
    CXX=$(xcrun --find --sdk "${SDK}" g++)
    export CPP
    CPP=$(xcrun --find --sdk "${SDK}" cpp)
    export CFLAGS
    CFLAGS="${HOST_FLAGS} ${OPT_FLAGS}"
    export CXXFLAGS
    CXXFLAGS="${HOST_FLAGS} ${OPT_FLAGS}"
    export LDFLAGS
    LDFLAGS="${HOST_FLAGS} -framework CoreAudio -framework AudioToolbox -framework CoreFoundation -framework CoreServices "

    ./configure --enalbe-mac-universal=false --host="${CHOST}" --prefix="${PREFIX}" --enable-static

    make clean
    make -j"${MAKE_JOBS}"
    #make install
}

SDK="iphoneos"
ARCH_FLAGS="-arch arm64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
CHOST="arm-apple-darwin"
PREFIX="${HOME}/DEVICE_ARM"
dobuild

#SDK="iphonesimulator"
#ARCH_FLAGS="-arch x86_64"
#HOST_FLAGS="${ARCH_FLAGS} -mios-simulator-version-min=8.0 -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
#CHOST="x86_64-apple-darwin"
#PREFIX="${HOME}/SIM_x86"
#dobuild

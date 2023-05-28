#!/bin/bash

TC_PATH="$HOME/Clang-16.0.5/bin/"

BUILD_ENV="CC=$(echo $TC_PATH)clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=$(echo $TC_PATH)aarch64-linux-gnu-"

KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"

case $1 in
   pgo)

   BUILD_ENV="$BUILD_ENV CONFIG_PGO_CLANG=y"
   ;;
esac

make O=out ARCH=arm64 $BUILD_ENV r8q_defconfig

make -j$(nproc --all) O=out ARCH=arm64 $KERNEL_MAKE_ENV $BUILD_ENV Image.gz

make -j$(nproc --all) O=out ARCH=arm64 $KERNEL_MAKE_ENV $BUILD_ENV dtbs

cp arch/arm64/boot/Image.gz AnyKernel3/Image.gz

DTB_OUT="out/arch/arm64/boot/dts/vendor/qcom"

cat $DTB_OUT/*.dtb > AnyKernel3/dtb

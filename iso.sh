#!/bin/sh
set -e
. ./build.sh
 
mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub
 
cp sysroot/boot/ilux.kernel isodir/boot/ilux.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "Ilux" {
	multiboot /boot/ilux.kernel
}
EOF
grub-mkrescue -o ilux.iso isodir

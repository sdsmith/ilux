
ASMC=i686-elf-as
CC=i686-elf-gcc
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra

KERNEL_LD=linker.ld



all: ilux.bin multiboot_check create_bootable

%.o: %.s
	$(ASMC) $^ -o $@

%.o: %.c
	$(CC) -c $^ -o $@ $(CFLAGS)

ilux.bin: linker.ld boot.o kernel.o
	$(CC) -T $< -o $@ -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc


.PHONY: clean multiboot_check create_bootable

multiboot_check: ilux.bin
	@grub-file --is-x86-multiboot $^; \
	if [ $$? -eq 0 ]; then \
		echo "$^: valid Multiboot Version 1 header"; \
	else \
		(>&2 echo "$^: invalid Multiboot Version 1 header"); \
		exit 1; \
	fi \

	@grub-file --is-x86-multiboot2 $^; \
	if [ $$? -eq 0 ]; then \
		echo "$^: valid Multiboot Version 2 header"; \
	else \
		(>&2 echo "$^: invalid Multiboot Version 2 header"); \
	fi \

create_bootable: ilux.bin multiboot_check
	@mkdir -p isodir/boot/grub
	@cp ilux.bin isodir/boot/ilux.bin
	@cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o ilux.iso isodir > /dev/null 2>&1

clean:
	@rm -f *.o
	@rm -f ilux.bin
	@rm -f ilux.iso
	@rm -rf isodir

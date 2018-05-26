# Declare multiboot header contstants 
  .set  ALIGN,     1<<0                 # align the loaded modules on page boundaries 
  .set  MEMINFO,   1<<1                 # provide memory map 
  .set  FLAGS,     ALIGN | MEMINFO      # multiboot 'flag' field 
  .set  MAGIC,     0x1BADB002           # magic in header for bootloader 
  .set  CHECKSUM,  -(MAGIC + FLAGS)     # checksum for multiboot header 
                      
# Declare multiboot header marking the program as kernel. Values are documented in the 
# multiboot standard. Bootloader searches for signature in the first 8 KiB of the kernel 
# file algined to a 32-bit boundary. 
# The signature is in its own section so the header can be forced to be within the first 
# 8KiB of the kernel file.
  .section .multiboot   
  .align 4                              # 32-bit alignment 
  .long MAGIC
  .long FLAGS
  .long CHECKSUM

# Allocate stack space
# Multiboot standard does not define the value of the stack pointer (esp), the kernel 
# must provide the stack.
# x86 stack must be 16 byte aligned according to the System V ABI standard.
  .section .bss
  .align 16
stack_bottom:
  .skip 16384   # 16 KiB
stack_top:  
  
# Bootloader defines _start as the kernel entry point.
# No need to return from the function as we are the kernel.
  .section .text
  .global _start
  .type _start, @function
_start:
        # Bootloader has loaded us into 32-bit protected mode on x86.
        # - interrupts are disabled
	# - paging is disabled
	# - processor in state defined by multiboot standard
	# - kernel has full CPU control

	# Set esp to top of stack (grows down on x86).
	mov $stack_top, %esp

	# NOTE(sdsmith): Good place to initialize crucial processor state before high-level kernel.
	# Minimize the time that the system is without its crucial features.
	# Processor is missing:
	# - floating point instructions
	# - instruction set extensions
	# - GDT initialization
	# - paging initialization
	# - C++ features (exceptions and global constructors) runtime support

	# Enter the high-level kernel
	# ABI requires the stack is 16-byte aligned at time of call.
	# IMPORTANT(sdsmith): Because we have pushed 0 bytes, we are still 16-byte aligned
	call kernel_main

	# Is the system has nothing more to do, put it into an infinite loop.
	# 1) Disable interrupts (cli)
	# 2) Wait for next interupt to occur (halt)
	# 3) Jump to halt if it ever wakes up (possibly due to a non-maskable interrupt or the
	#    system management mode.
	cli
lock_sys:
        hlt
        jmp lock_sys

# Set the size of the _start symbol to the current location ('.') minus its start.
# Useful for debugging and call tracing.
  .size _start, . - _start

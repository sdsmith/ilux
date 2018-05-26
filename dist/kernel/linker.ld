/* Bootloader will start execution at this entry point. */
ENTRY(_start)

/* Designate where section of the object files will be put in the final kernel image. */
SECTIONS
{
        /* Start by putting section at 1 MiB. This is a conventional place for kernels to be 
           loaded from by the bootloader. */

        . = 1M;

        /* Multiboot header first, or the bootlafer won't scan far enough to find it. */
        .text BLOCK(4K) : ALIGN(4K)
        {
                *(.multiboot)
                *(.text)
        }

        /* Read-only data */
        .rodata BLOCK(4K) : ALIGN(4K)
        {
                *(.rodata)
        }

        /* Read-write data (initialized) */
        .data BLOCK(4K) : ALIGN(4K)
        {
                *(.data)
        }

        /* Read-write data (uninitialized) and stack */
        .bss BLOCK(4K) : ALIGN(4K)
        {
                *(COMMON)
                *(.bss)
        }

        /* NOTE(sdsmith): The compiler may produce other sections. By default it will put them
           in a segment with the same name. Add stuff here as needed. */
}

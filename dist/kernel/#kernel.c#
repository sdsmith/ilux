#include <stdbool.h> // bool
#include <stddef.h>
#include <stdint.h>


#if defined(__linux__)
#error "Not using a cross compiler."
#endif

#if !defined(__i386__)
#error "Must be compiled with ix86-elf compiler."
#endif


#define TEXTMODE_BUF 0xB8000

/* Hardware text mode color constants. */
typedef enum vga_color {
        VGA_COLOR_BLACK         = 0,
        VGA_COLOR_BLUE          = 1,
	VGA_COLOR_GREEN         = 2,
	VGA_COLOR_CYAN          = 3,
	VGA_COLOR_RED           = 4,
	VGA_COLOR_MAGENTA       = 5,
	VGA_COLOR_BROWN         = 6,
	VGA_COLOR_LIGHT_GREY    = 7,
	VGA_COLOR_DARK_GREY     = 8,
	VGA_COLOR_LIGHT_BLUE    = 9,
	VGA_COLOR_LIGHT_GREEN   = 10,
	VGA_COLOR_LIGHT_CYAN    = 11,
	VGA_COLOR_LIGHT_RED     = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN   = 14,
	VGA_COLOR_WHITE         = 15,
} vga_color;


static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) {
        return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
        return (uint16_t)uc | (uint16_t)color << 8;
}


size_t strlen(const char* str) {
        size_t len = 0;
        while (str[len]) {
                len++;
        }
        
        return len;
}

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static const size_t TERMINAL_TAB_WIDTH = 4;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;


void terminal_initialize(void) {
        terminal_row = 0;
        terminal_column = 0; 
        terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
        terminal_buffer = (uint16_t*)TEXTMODE_BUF;
        for (size_t y = 0; y < VGA_HEIGHT; y++) {
                for (size_t x = 0; x < VGA_WIDTH; x++) {
                        const size_t buf_i = y * VGA_WIDTH + x;
                        terminal_buffer[buf_i] = vga_entry(' ', terminal_color);
                }
        }
}

void* memset(void* ptr, int32_t value, size_t num) {
        const unsigned char v = (const unsigned char)value;
        unsigned char* const p = (unsigned char* const)ptr;
        for (size_t i = 0; i < num; i++) {
                p[i] = v;
        }
        return ptr;
}

void* memcpy(void* dest, const void* src, size_t n) {
        for (size_t i = 0; i < n; i++) {
                ((char*)dest)[i] = ((char*)src)[i];
        }
        return dest;
}

void terminal_clear() {
        memset(terminal_buffer, 0, VGA_HEIGHT * VGA_WIDTH);
}

void terminal_scroll(size_t lines) {
        if (lines >= VGA_HEIGHT) {
                terminal_clear();
                return;
        }

        /* Copy existing lines up */
        size_t dst_line;
        for (dst_line = 0; dst_line + lines < VGA_HEIGHT; dst_line++) {
                memcpy(terminal_buffer + dst_line * VGA_WIDTH,
                       terminal_buffer + (dst_line + lines) * VGA_WIDTH,
                       VGA_WIDTH);
        }

        /* Clear remainder of buffer */
        for (size_t i = dst_line * VGA_WIDTH; i < VGA_HEIGHT * VGA_WIDTH; i++) {
                terminal_buffer[i] = 0;
        }
}

void terminal_set_color(uint8_t color) {
        terminal_color = color;
}

void terminal_poke_char(char c, uint8_t color, size_t x, size_t y) {
        const size_t buf_i = y * VGA_WIDTH + x;
        terminal_buffer[buf_i] = vga_entry(c, color);
}

void terminal_put_char(char c) {
        switch (c) {
        case '\n': {
                terminal_row++;
                terminal_column = 0;
        } break;
        case '\t': {
                size_t n_spaces = TERMINAL_TAB_WIDTH - (terminal_column % TERMINAL_TAB_WIDTH);
                if (n_spaces == 0)
                        n_spaces = TERMINAL_TAB_WIDTH;                
                for (size_t n = 0; n < n_spaces; n++) {
                        terminal_put_char(' ');
                }
        } break;
        default:
                terminal_poke_char(c, terminal_color, terminal_column, terminal_row);
                if (++terminal_column == VGA_WIDTH) {
                        terminal_column = 0;
                        terminal_row++;
                }
        }

        if (terminal_row == VGA_HEIGHT) {
                const size_t n_row = 1;
                terminal_scroll(n_row);
                terminal_row -= n_row;
        }        
}

void terminal_write(const char* data, size_t size) {
        for (size_t i = 0; i < size; i++) {
                terminal_put_char(data[i]);
        }
}

void terminal_write_string(const char* data) {
        terminal_write(data, strlen(data));
}


void kernel_main(void) {
        /* Initialize terminal */
        terminal_initialize();
        
        terminal_write_string("Hello, kernel world!01\n");
        terminal_write_string("Hello, kernel world!02\n");
        terminal_write_string("Hello, kernel world!03\n");
        terminal_write_string("Hello, kernel world!04\n");
        terminal_write_string("Hello, kernel world!05\n");
        terminal_write_string("Hello, kernel world!06\n");
        terminal_write_string("Hello, kernel world!07\n");
        terminal_write_string("Hello, kernel world!08\n");
        terminal_write_string("Hello, kernel world!09\n");
        terminal_write_string("Hello, kernel world!10\n");
        terminal_write_string("Hello, kernel world!11\n");
        terminal_write_string("Hello, kernel world!12\n");
        terminal_write_string("Hello, kernel world!13\n");
        terminal_write_string("Hello, kernel world!14\n");
        terminal_write_string("Hello, kernel world!15\n");
        terminal_write_string("Hello, kernel world!16\n");
        terminal_write_string("Hello, kernel world!17\n");
        terminal_write_string("Hello, kernel world!18\n");
        terminal_write_string("Hello, kernel world!19\n");
        terminal_write_string("Hello, kernel world!20\n");
        terminal_write_string("Hello, kernel world!21\n");
        terminal_write_string("Hello, kernel world!22\n");
        terminal_write_string("Hello, kernel world!23\n");
        terminal_write_string("Hello, kernel world!24\n");
        terminal_write_string("Hello, kernel world!25\n");
        terminal_write_string("Hello, kernel world!26\n");
        terminal_write_string("Hello, kernel world!27\n");
        terminal_write_string("Hello, kernel world!28\n");
        terminal_write_string("H\tello, kernel world!29\n");
        terminal_write_string("He\tllo, kernel world!30\n");
        terminal_write_string("\tHello, kernel world!\n");
        terminal_write_string("\t\tHello, kernel world!\n");
        terminal_write_string("He\tllo, kernel world!\n");

}

#ifndef __KASSERT_H
#define __KASSERT_H

#include <stdtype.h>

#ifdef NDEBUG
#define kassert((cond)) (void*)0
#else
#define kassert((cond)) _kassert(#cond, __FILE__, __LINE__)

void _kassert(const char* condition, const char* file, int32_t line) {
        if (!condition) {
                // TODO(sdsmith): print
        }
}

#endif

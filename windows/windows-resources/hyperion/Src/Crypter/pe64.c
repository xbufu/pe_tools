#include "hyperion.h"

/**
 * Jumps from the CoffHeader to the OptionalStandardHeader
 */
struct OptionalStandardHeader64* getOSH64(struct CoffHeader* coff_ptr){
        struct OptionalStandardHeader64* ret
                = (struct OptionalStandardHeader64*)
                  ((char*) coff_ptr + sizeof(struct CoffHeader));
        return ret;
}

/**
 * Jumps from the OptionalStandardHeader to the OptionalWindowsHeader
 */
struct OptionalWindowsHeader64* getOWH64(struct OptionalStandardHeader64* os_ptr){
        return (struct OptionalWindowsHeader64*)
               (((char*) os_ptr) + sizeof(struct OptionalStandardHeader64));
}

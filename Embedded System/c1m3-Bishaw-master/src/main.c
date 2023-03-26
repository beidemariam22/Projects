#include "course1.h"
#include "platform.h"

int main(void) {
#ifdef COURSE1
    course1();
#elif TEST_DATA1
    return test_data1();
#elif TEST_DATA2
    return test_data2();
#elif TEST_MEMMOVE1
    return test_memmove1();
#elif TEST_MEMMOVE2
    return test_memmove2();
#elif TEST_MEMMOVE3
    return test_memmove3();
#elif TEST_MEMCOPY
    return test_memcopy();
#elif TEST_MEMSET
    return test_memset();
#elif TEST_REVERSE
    return test_reverse();
#else
    PRINTF("Use the following command:\n\tmake DFLAGS=\"-DVERBOSE -DCOURSE1\"  build; ./c1m3.out\nMake sure your working directory is src, the makefile is located there. Change the COURSE1 flag to change the test\n");
#endif
    return 0;
}
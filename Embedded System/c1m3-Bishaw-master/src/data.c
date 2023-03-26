/**
 * @file data.h
 * @brief TThis file should do some very basic data manipulation.
 *
 * @author Andreu gimenez
 * @date April 4, 2021
 *
 */

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <math.h>
#include "data.h"
#include "memory.h"
#include "platform.h"

#define NULL_ASCII 0 // 0 is the ascii code for NULL
#define NEGATIVE_ASCII 45 // 45 is the ascii code of the negative sign
#define ZERO_ASCII 48 // 48 is the ascii code for 0
#define A_ASCII 65 // 65 is the ascii code for A
#define ALPHA_ASCII (A_ASCII - 10) // What needs to be added to get the char ascii value of a number greater than 9

uint8_t my_itoa(int32_t data, uint8_t* ptr, uint32_t base) {
    // Add the null terminator
    *ptr = NULL_ASCII; ptr++;
    uint8_t length = 1;
    uint8_t next_val;
    bool negative = false;
    // Check the sign first
    if (data < 0) {
        negative = true;
        data = abs(data);
    }
    // Add all digits
    while (data > 0) {
        next_val = data % base;
        if (next_val > 9) {
            *ptr = ALPHA_ASCII + next_val;
        } else {
            *ptr = ZERO_ASCII + next_val;
        }
        ptr++; length++;
        data = data / base;
    }
    // Add the negative sign
    if (negative) {
        *ptr = NEGATIVE_ASCII; ptr++; length++;
    }
    // Reverse the array
    ptr = ptr - length;
    my_reverse(ptr, length);
    return length;
}

int32_t my_atoi(uint8_t* ptr, uint8_t digits, uint32_t base) {
    int32_t result = 0;
    int32_t temp;
    bool negative = false;
    for (uint8_t i = 1; i++ <= digits;) {
        if (*ptr < ZERO_ASCII) {
            if (*ptr == NEGATIVE_ASCII) {
                i--; digits--;
                negative = true;
            } else if (*ptr == NULL_ASCII) {
                break;
            } else { // Unknonw char
                exit(-1);
            }
        } else {
            if (*ptr >= A_ASCII) {
                temp = (*ptr-ALPHA_ASCII);
            } else {
                temp = (*ptr-ZERO_ASCII);
            }
            for (uint8_t k = 1; k++ <= digits-i;) {
                temp *= base;
            }
            result += temp;
        }
        ptr++;
    }
    if (negative) {
        result = -result;
    }
    return result;
}
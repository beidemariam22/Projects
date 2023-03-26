#******************************************************************************
# Copyright (C) 2017 by Alex Fosdick - University of Colorado
#
# Redistribution, modification or use of this software in source or binary
# forms is permitted as long as the files maintain this copyright. Users are 
# permitted to modify this and use it to learn about the field of embedded
# software. Alex Fosdick and the University of Colorado are not liable for any
# misuse of this material. 
#
#*****************************************************************************

#------------------------------------------------------------------------------
# Peer-graded Assignment: Week 2 Application Assignment
#
# Use: make [TARGET] [PLATFORM-OVERRIDES]
#
# Build Targets:
#      main.o main.asm memory.o etc.
#
# Platform Overrides:
#      HOST or MSP432
#
#------------------------------------------------------------------------------
# Platform Overrides
PLATFORM = HOST

include ./sources.mk

# Architectures Specific Flags
CPU = cortex-m4
THUMB = thumb
ARCH = armv7e-m
SPECS = nosys.specs
FLOAT_ABI = hard
FPU = fpv4-sp-d16
LINKER_FILE = ../msp432p401r.lds

# Platform Specific Flags
ifeq ($(PLATFORM),HOST)
	CC = gcc
	LDFLAGS = -Wl,-Map=$(TARGET).map
	CPPFLAGS = -DHOST
else
	CC = arm-none-eabi-gcc
	LDFLAGS = -Wl,-Map=$(TARGET).map -T $(LINKER_FILE)
	CPPFLAGS = -DMSP432 -mcpu=$(CPU) -march=$(ARCH) -m$(THUMB) --specs=$(SPECS) -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
endif

# Compiler Flags and Defines
LD = arm-none-eabi-ld
TARGET = c1m2
CFLAGS = -Wall -Werror -g -O0 -std=c99


# Generate the preprocessed output of all c-program implementation files (use
# the –E flag).
%.i : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $(LDFLAGS) -E -M -MF $(^:.c=.d) $^ > $@

# Generate assembly output of c-program implementation files and the final
# output executable (Use the –S flag and the objdump utility).
%.asm : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $(LDFLAGS) $^ -o $(^:.c=.out)
	objdump -S $(^:.c=.out) > $@

# Generate the object file for all c-source files (but do not link) by
# specifying the object file you want to compile.
%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $(LDFLAGS) -c $^ 

# Compile all object files, but DO NOT link.
.PHONY: compile-all
compile-all:
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $(LDFLAGS) $(SOURCES) -c $^ 

# Compile all object files and link into a final executable.
.PHONY: build
build:
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $(LDFLAGS) $(SOURCES) -o $(TARGET).out $^ 

OBJS = $(SOURCES:.c=.o)

# This should remove all compiled objects, preprocessed outputs, assembly
# outputs, executable files and build output files.
.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET).map $(TARGET).out $(SOURCES:.c=.asm) $(SOURCES:.c=.i) $(SOURCES:.c=.out) $(SOURCES:.c=.d)
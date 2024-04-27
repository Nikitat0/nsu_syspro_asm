.PHONY: all clean

INCLUDES = $(wildcard macro*.nasm)
LIB_SOURCES = $(wildcard lib*.nasm)
BIN_SOURCES = $(wildcard task*.nasm)
TEST_SOURCES = $(wildcard test*.nasm)
LIB = $(LIB_SOURCES:%.nasm=build/%.o)
BIN = $(BIN_SOURCES:%.nasm=build/%)
TEST = $(TEST_SOURCES:%.nasm=build/%)
PASSED = $(TEST:%=%.passed) 

all: test $(BIN)

test: $(PASSED)

clean:
	@rm -rf build bin

build:
	@mkdir -p build

$(LIB): build/%.o:%.nasm $(INCLUDES) | build
	nasm -f elf64 $(INCLUDES:%=-p %) -Ox -o $@ $<

$(TEST): build/%:%.nasm $(LIB) $(INCLUDES) | build
	nasm -f elf64 $(INCLUDES:%=-p %) -Ox -o $@.o $<
	ld -r -e --gc-sections -e main -o $@.pre $@.o $(LIB)
	gcc -lc -o $@ $@.pre

$(PASSED): %.passed:% | build
	@./$<
	@touch $@

$(BIN): build/%:%.nasm $(LIB) $(INCLUDES) | build
	nasm -f elf64 $(INCLUDES:%=-p %) -Ox -o $@.o $<
	ld -r -e --gc-sections -e main -o $@.pre $@.o $(LIB)
	gcc -lc -o $@ $@.pre

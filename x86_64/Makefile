.PHONY: all clean

INCLUDES = $(wildcard macro*.nasm)
LIB_SOURCES = $(wildcard lib*.nasm)
BIN_SOURCES = $(wildcard task*.nasm)
LIB = $(LIB_SOURCES:%.nasm=build/%.o)
BIN = $(BIN_SOURCES:%.nasm=build/%)

all: $(BIN)

clean:
	@rm -rf build bin

build:
	@mkdir -p build

$(LIB): build/%.o:%.nasm $(INCLUDES) | build
	nasm -f elf64 $(INCLUDES:%=-p %) -Ox -o $@ $<

$(BIN): build/%:%.nasm $(LIB) $(INCLUDES) | build
	nasm -f elf64 $(INCLUDES:%=-p %) -Ox -o $@.o $<
	gcc -lc -o $@ $@.o $(LIB)

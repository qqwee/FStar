# Override to get cross-compilation
MARCH?=$(shell uname -m)
UNAME?=$(shell uname | cut -c 1-6)

ifeq ($(UNAME),CYGWIN)
  CC=$(MARCH)-w64-mingw32-gcc
else ifeq ($(MARCH),i686)
  CC=gcc -m32 -fPIC
else
  CC=gcc -fPIC
endif

ifeq ($(UNAME),Darwin)
  VARIANT=-Darwin
else ifeq ($(UNAME),Linux)
  VARIANT=-Linux
endif


all: aes.o sha256.o

%.o: %-$(MARCH)$(VARIANT).S
	$(CC) -c $< -o $@

.PHONY: import
import:
	@if [ x"$(VALE_HOME)" = x ]; then echo "VALE_HOME not defined"; exit 1; fi
	cp $(VALE_HOME)/obj/aes-gcc.S aes-x86_64.S
	cp $(VALE_HOME)/obj/aes-macos.S aes-x86_64-Darwin.S
	cp $(VALE_HOME)/obj/aes-linux.S aes-x86_64-Linux.S
# TODO: Vale SHA256 not built on Linux yet
ifneq ($(UNAME),Linux)
	cp $(VALE_HOME)/obj/sha256-gcc.S sha256-x86_64.S
	cp $(VALE_HOME)/obj/sha256-macos.S sha256-x86_64-Darwin.S
	cp $(VALE_HOME)/obj/sha256-linux.S sha256-x86_64-Linux.S
endif
	sed -i.bak 's/.section .text/.text/' *.S

clean:
	rm -f *.o *~

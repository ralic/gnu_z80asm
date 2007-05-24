# Makefile for the Z80 assembler by shevek
# Copyright (C) 2002-2005  Bas Wijnen
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

CC = gcc
CFLAGS = -O0 -Wall -Wwrite-strings -Wcast-qual -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -pedantic -ansi -Wshadow -ggdb3 -W -Ignulib
SHELL = /bin/bash
VERSION ?= $(shell echo -n `cat VERSION | cut -d. -f1`. ; echo $$[`cat VERSION | cut -d. -f2` + 1])

all:z80asm

z80asm: z80asm.o expressions.o Makefile gnulib/getopt.o gnulib/getopt1.o
	$(CC) $(LDFLAGS) $(filter %.o,$^) -o $@
	$(MAKE) -C tests

%.o:%.c z80asm.h gnulib/getopt.h Makefile
	$(CC) $(CFLAGS) -c $< -o $@ -DVERSION=\"$(shell cat VERSION)\"

clean:
	for i in . gnulib examples headers ; do \
		rm -f $$i/core $$i/*~ $$i/\#* $$i/*.o $$i/*.rom ; \
	done
	rm -f z80asm z80asm.exe

dist: clean
	echo $(VERSION) > VERSION
	rm -rf /tmp/z80asm-$(VERSION) /tmp/z80asm
	tar cf - -C .. z80asm | tar xf - -C /tmp
	find /tmp/z80asm -name CVS | xargs rm -rf
	mv /tmp/z80asm /tmp/z80asm-$(VERSION)
	tar cvzf ../z80asm-$(VERSION).tar.gz -C /tmp z80asm-$(VERSION)

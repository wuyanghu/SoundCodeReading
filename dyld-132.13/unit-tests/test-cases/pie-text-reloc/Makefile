##
# Copyright (c) 2007-2008 Apple Inc. All rights reserved.
#
# @APPLE_LICENSE_HEADER_START@
# 
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apple Public Source License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://www.opensource.apple.com/apsl/ and read it before using this
# file.
# 
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
# 
# @APPLE_LICENSE_HEADER_END@
##
TESTROOT = ../..
include ${TESTROOT}/include/common.makefile

EXTRA_OPTIONS = -mdynamic-no-pic -read_only_relocs suppress

ifeq "x86_64" "$(ARCH)"
	EXTRA_OPTIONS = 
endif


# run a PIE four times and verify its load address was different every time

all-check: all check

check:
	./main > main.out
	./main >> main.out
	./main >> main.out
	./main >> main.out
	if [ `sort main.out -u | wc -l` == 4 ]; \
	then \
		echo "PASS pie-basic"; \
	else \
		echo "FAIL pie-basic"; \
	fi; \
	 
all: main

main : main.c
	${CC} ${CCFLAGS} -I${TESTROOT}/include -Wl,-pie  $(EXTRA_OPTIONS) -o main main.c -mmacosx-version-min=10.5


clean:
	${RM} ${RMFLAGS} *~ main main.out


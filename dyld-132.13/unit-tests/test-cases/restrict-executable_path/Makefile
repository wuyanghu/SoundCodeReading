##
# Copyright (c) 2006-2009 Apple Inc. All rights reserved.
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

SHELL = bash # use bash shell so we can redirect just stderr


#
# Use of @exectuable_path in restricted binaries is not allowed
# Use of @loader_path in restricted binaries is not allowed
# Use of relative paths in restricted binaries is not allowed
#

all-check: all check

check:
	${TESTROOT}/bin/exit-non-zero-pass.pl "restrict-executable_path @executable_path" "restrict-executable_path @executable_path" ./main_exe "restrict-executable_path"
	${TESTROOT}/bin/exit-non-zero-pass.pl "restrict-executable_path @loader_path" "restrict-executable_path @loader_path" ./main_loader "restrict-executable_path"
	${TESTROOT}/bin/exit-non-zero-pass.pl "restrict-executable_path relative path" "restrict-executable_path relative path" ./main_rel "restrict-executable_path"



all: main_exe  main_loader main_rel 

dir1/libfoo.dylib : foo.c
	mkdir -p dir1
	${CC} ${CCFLAGS} foo.c -dynamiclib -o dir1/libfoo.dylib -install_name @executable_path/dir1/libfoo.dylib

dir2/libbar.dylib : foo.c
	mkdir -p dir2
	${CC} ${CCFLAGS} foo.c -dynamiclib -o dir2/libbar.dylib -install_name @loader_path/dir2/libbar.dylib

dir3/libbaz.dylib : foo.c
	mkdir -p dir3
	${CC} ${CCFLAGS} foo.c -dynamiclib -o ./dir3/libbaz.dylib

main_exe: main.c dir1/libfoo.dylib
	${CC} ${CCFLAGS} -I${TESTROOT}/include -o main_exe main.c dir1/libfoo.dylib -sectcreate __RESTRICT __restrict /dev/null
	
main_loader: main.c dir2/libbar.dylib
	${CC} ${CCFLAGS} -I${TESTROOT}/include -o main_loader main.c dir2/libbar.dylib -sectcreate __RESTRICT __restrict /dev/null

main_rel: main.c dir3/libbaz.dylib
	${CC} ${CCFLAGS} -I${TESTROOT}/include -o main_rel main.c dir3/libbaz.dylib -sectcreate __RESTRICT __restrict /dev/null



clean:
	${RM} ${RMFLAGS} *~ main_exe  main_loader  main_rel  dir1 dir2 dir3


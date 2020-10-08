#!/bin/bash

cd godot
scons -j`nproc` platform=linuxbsd use_llvm=yes use_lld=yes tools=yes target=release_debug

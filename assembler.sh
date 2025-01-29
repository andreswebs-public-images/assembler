#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset

file_name="${1%%.*}"
ext="${1##*.}"
debug="${2:-noop}"

if [[ "${ext}" != "asm" && "${ext}" != "s" ]]; then
  >&2 echo "Error: unsupported file extension. Only .asm or .s files are supported."
  exit 1
fi

nasm -f elf64 "${file_name}.${ext}"
ld "${file_name}.o" -o "${file_name}"

if [ "${debug}" == "-g" ] || [ "${debug}" == "--gdb" ] || [ "${debug}" == "--debug" ]; then
  gdb -q "$(pwd)/${file_name}"
else
  "$(pwd)/${file_name}"
fi

#!/bin/bash
realpath "$0"
whoami
echo "$PPID"
echo "$$"
pwd
echo "$HOME"
echo "$PATH"
echo "${LAB_MODE:-UNSET}"

#!/bin/sh

git log --format='%an' "$@" | sort | uniq -c | sort -rn

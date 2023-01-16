#!/usr/bin/env bash

files=$(find . -name "PKGBUILD")
for f in $files
do
        d=$(dirname "$f")
        cd "$d"  || exit
		makepkg -s --noconfirm --skippgpcheck "$@"
        cd ..
done

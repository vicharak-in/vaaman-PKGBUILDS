#!/usr/bin/env bash

files=$(find . -name "PKGBUILD")
for f in $files
do
        d=$(dirname "$f")
        cd "$d"  || exit
		makepkg -s --noconfirm --skippgpcheck "$@"
		rm -rf src pkg
        cd ..
done

#!/usr/bin/env bash

files=$(find . -name "PKGBUILD")
for f in $files
do
        d=$(dirname "$f")
        cd "$d"  || exit
		makepkg -s --noconfirm --skippgpcheck "$@"
		makepkg --printsrcinfo > .SRCINFO
		rm -rf src pkg "$d"
        cd ..
done

# repo-add to vaaman.db
files=$(find . -name "*.pkg.tar.zst")
for f in $files
do
		repo-add vaaman.db.tar.gz "$f"
done

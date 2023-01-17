#!/usr/bin/env bash
set -e

path="/usr/share/nginx/html/vaaman"

files=$(find . -name "PKGBUILD")
for f in $files; do
	d=$(dirname "$f")

	# check if the package ends with -git
	if [[ $d == *-git ]]; then
		d=${d:2}
		f=${f:2}

		if [[ ! -d $path/$d ]]; then
			sudo mkdir -p $path/$d
		fi

		# copy the PKGBUILD to the path
		sudo cp -avf "$f" "$path/$d/PKGBUILD"

	else
		cd "$d" || exit
		makepkg -s -f --noconfirm --skippgpcheck "$@"
		makepkg --printsrcinfo >.SRCINFO

		build_files=$(find . -name "*.tar.zst")
		sudo cp -av $build_files /usr/share/nginx/html/vaaman/

		cd .. || exit
	fi
done

# repo-add to vaaman.db
files=$(find . -name "*.tar.zst")
echo "Updating vaaman.db with $files"

for f in $files; do
	f=${f:2}
	sudo repo-add -s -n -R /usr/share/nginx/html/vaaman/vaaman.db.tar.zst "$f"
done

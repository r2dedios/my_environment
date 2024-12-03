#!/usr/bin/env bash

image_screenshot() {
	local image="$1"

	DS=10
	US="$( bc <<< "10000 / $DS" )"

	xwd -root | convert xwd:- "$image"
	size="$(identify -format "%wx%h" "$image" )"
	#convert "$image" -colorspace Gray -scale $DS% -scale $US% -resize "$size" "$image"

	convert "$image" -scale $DS% -scale $US% -resize "$size" "$image"

	#convert "$image" -blur 0x5 "$image"

	echo "$image"
}

image_wallpaper() {
	#echo '/home/carlos/Pictures/the_expanse_2k.2.jpg'
	convert '/tmp/the_expanse_2k.2.jpg' -colorspace Gray "$1"
	echo "$1"
}

image() {
	#image_wallpaper $@
	image_screenshot $@
}

#!/usr/bin/env bash

DWLINK='https://archive.org/download/PowerPointViewer_201801/PowerPointViewer.exe'
set -e
# set -x

if [ -d "temp" ]; then
    rm -r temp
fi
mkdir temp
cd temp

wget -q --show-progress --progress=bar:force $DWLINK

if [ ! $(command -v cabextract) ]; then
    echo "cabextract not found! Please install it."
    exit 1
fi
cabextract -q -L -F ppviewer.cab PowerPointViewer.exe
cabextract -q -F *.TTF ppviewer.cab

find . -not -name 'CONSOLA*' -delete

chmod --quiet 644 CONSOLA*

for FILE in *; do
	NEWNAME=$(ls "$FILE" | sed 's/CONSOLA/CONSOLAS/')
    mv "$FILE" "$NEWNAME"
done

sudo cp -ar ../temp /usr/share/fonts/consolas

rm -r -v ../temp

cd /usr/share/fonts/consolas

sudo mkfontscale && sudo mkfontdir && sudo fc-cache -fv

echo "Done"

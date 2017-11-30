#! /usr/local/bin/bash

for font_file in ./*/*.ttf; do
    sudo cp -R $font_file $HOME/Libarary/Fonts/
done


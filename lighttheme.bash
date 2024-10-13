#!/usr/bin/env bash

sed -i -r 's/(include)\ .*conf/\1 light-theme.conf/g' /home/morris/.config/kitty/kitty.conf 
sed -i -r 's/(^vim\.cmd\(\"colorscheme)\ .*\"\)/\1 adwaita\"\)/g' /home/morris/.config/nvim/init.lua 

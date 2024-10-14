#!/usr/bin/env bash

sed -i -r 's/(include)\ .*conf/\1 dark-theme.conf/g' /home/morris/.config/kitty/kitty.conf
# cat /home/morris/.config/nvim/init.lua | sed -r 's/(^vim\.cmd\(\"colorscheme)\ .*\"\)/\1 catppuccin-mocha\"\)/g' > /home/morris/.config/nvim/init.lua 
 sed -i -r 's/(^vim\.cmd\(\"colorscheme)\ .*\"\)/\1 catppuccin-mocha\"\)/g' /home/morris/.config/nvim/init.lua

# cat /home/morris/.config/nvim/init.lua | sed -r 's/catppuccin-mocha/adwaita/g' > /home/morris/.config/nvim/example.lua


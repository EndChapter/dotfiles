# !/bin/bash

if [[ $* == "1" ]];then
    ln -sf ~/.config/i3/configs/main /home/edch/.config/i3/config
    i3-msg restart
else
    ln -sf ~/.config/i3/configs/gamemode /home/edch/.config/i3/config
    i3-msg restart
fi

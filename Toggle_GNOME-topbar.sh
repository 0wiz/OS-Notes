#!/bin/bash

status_file=~/.config/Topbars.txt

if grep "True" "$status_file"
then
    gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval string:'Main.panel.actor.hide();'
    echo "False" > "$status_file"
else
    gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval string:'Main.panel.actor.show();'
    echo "True" > "$status_file"
fi

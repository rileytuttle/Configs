#!/bin/bash

do_not_disturb_mode=false
app_name="opt/zoom/zoom"
cpu_limit="1800"

while :
do
    app_pid=$(ps aux | grep $app_name | grep -Ev '(grep|rg|export)' | awk {'print $2'})
    app_cpu=$(top -b -d1 -n1 | grep $app_pid | awk {'print $9*100'})
    was_in_dnd_mode=$do_not_disturb_mode

    if [[ $app_cpu -gt $cpu_limit ]]; then
        do_not_disturb_mode=true
    else
        do_not_disturb_mode=false
    fi
    if [ "$do_not_disturb_mode" = true ] && [ "$was_in_dnd_mode" = false ]; then
        echo "turning on do not disturb zoom at $app_cpu $(date)" >> do-not-disturb.txt
        echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --color 255 0 0 --wait 10"
    elif [ "$do_not_disturb_mode" = false ] && [ "$was_in_dnd_mode" = true ]; then
        echo "turning off do not disturb zoom at $app_cpu $(data)" >> do-not-disturb.txt
        echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --clear"
    fi
    # else
    # # can enable this when I can figure out how to not wipe the leds. instead quietly changing them
    #     means=$(python3 get_average_screen.py)
    #     echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --color $means --wait 10"
    # fi
    sleep 1
done

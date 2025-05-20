monitors=$(hyprctl monitors -j)
hyprconf=/home/$(whoami)/.config/hypr/monitors.conf
positions=$'auto\nauto-left\nauto-right\nauto-up\nauto-down'
scales=$'auto\n1\n1.5\n2'

count= expr $(echo $monitors | jq -r '.[-1].id') + 1
monitor=$(echo $monitors | jq -r '.[].description' | wofi --dmenu -p "Monitors")
if [ -z "$monitor"]; then
    exit 0;
else
    monitor_data=$(echo $monitors | jq -r ".[] | select(.description == \"$monitor\")")
    id=$(echo $monitor_data | jq -r ".name")
    res=$(echo $monitor_data | jq -r ".availableModes.[]" | wofi --dmenu -p "Select resolution and refresh rate")
    if [ -z "$res" ]; then
        exit 0
    fi
    pos=$(echo "$positions" | wofi --dmenu -p "Select position")
    if [ -z "$pos" ]; then
        exit 0
    fi
    scale=$(echo "$scales" | wofi --dmenu -p "Select scale")
    if [ -z "$scale" ]; then
        exit 0
    fi
    hypr_str="monitor=${id},${res::-2},${pos},${scale}"
    if grep -q "=$id," "$hyprconf"
    then
        sed -i -e "s#monitor=$id.*#$hypr_str#g" "$hyprconf"
    else
        echo $hypr_str >> "$hyprconf"
    fi
    hyprctl reload
fi

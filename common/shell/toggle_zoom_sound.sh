#!/bin/sh

main(){
app_name="ZOOM VoiceEngine"

current_sink_num=''
sink_num_check=''
app_name_check=''

toggleVolume

}

toggleVolume(){
    pactl list sink-inputs |while read line; do \
        sink_num_check=$(echo "$line" |sed -rn 's/^Sink Input #(.*)/\1/p')
        if [ "$sink_num_check" != "" ]; then
            current_sink_num="$sink_num_check"
        else
            app_name_check=$(echo "$line" \
                |sed -rn 's/application.name = "([^"]*)"/\1/p')
            if [ "$app_name_check" = "$app_name" ]; then
                pactl set-sink-input-mute "$current_sink_num" toggle
            fi
        fi
    done
}

main
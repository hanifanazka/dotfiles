#!/usr/bin/env bash
# Simple script that does 3 things:
# - handles startup and kill commands
# - changes volume, mute status, shows gui settings
# - shows appropriate wob overlay if anything changed
# Mainly written to work with PulseAudio but can be modified for alsa
# Also available here: https://framagit.org/-/snippets/6723
# Utilizes Wayland based overlay progress bar program - wob
# License: CC0 1.0 Universal
# Requirements: wob (and Wayland), pulseaudio, pavucontrol or pavucontrol-qt, bash
# Example usage:
# $ ./volume.sh startup &
# $ ./volume.sh up
# $ ./volume.sh down
# $ ./volume.sh togglemute
# $ ./volume.sh kill

command="$1"
show=''

if [ "$command" == 'up' ]; then
	pamixer -i 5
	show=true
elif [ "$command" == 'down' ]; then
	pamixer -d 5
	show=true
elif [ "$command" == 'togglemute' ]; then
	pamixer --toggle-mute
	show=true
elif [ "$command" == 'mute' ]; then
	pactl set-sink-mute @DEFAULT_SINK@ 1
	show=true
elif [ "$command" == 'unmute' ]; then
	pactl set-sink-mute @DEFAULT_SINK@ 0
	show=true
elif [ "$command" == 'settings' ]; then
	pavucontrol || pavucontrol-qt
elif [ "$command" == 'startup' ]; then # isn't used in this config, just here as reference
	rm -f "${XDG_RUNTIME_DIR}/wob.sock" && mkfifo "${XDG_RUNTIME_DIR}/wob.sock" && tail -f "${XDG_RUNTIME_DIR}/wob.sock" | wob
elif [ "$command" == 'kill' ]; then # run when wob is no longer needed
	pkill wob
fi

if [ -n "$show" ]; then
	volume_amount="$(pamixer --get-volume)"
	style=''
	# if muted, change the background color to red
	[ "$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')" == 'yes' ] && style='muted'
	echo "${volume_amount} ${style}" > "${XDG_RUNTIME_DIR}/wob.sock"
fi

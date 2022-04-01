#
# ~/.bash_profile
#


# Start X server
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	exec startx
fi

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

PATH=$PATH:/usr/local/texlive/2024/bin/x86_64-linux
PATH=$PATH:~/.bin
PATH=$PATH:/home/hanifanazka/.local/bin
PATH=$PATH:/home/hanifanazka/.fly/bin
PATH=$PATH:/home/hanifanazka/.cargo/bin

# export BAT_THEME="GitHub"

function pdfcompress() {
    gs -sDEVICE=pdfwrite \
	    -dCompatibilityLevel=1.4 \
	    -dPDFSETTINGS=/printer \
	    -dNOPAUSE \
	    -dBATCH \
	    -dQUIET \
	    ${*: 1:$#-2} \
	    -sOutputFile="${*: -1:1}" "${*: -2:1}";
}

function batstat() {
    tail -n 100 /var/lib/upower/history-charge-DELL_2X39G78-59-4984.dat \
	    | gnuplot -p -e \
	    'set xdata time; set timefmt "%s"; set format x "%H:%M"; plot "/dev/stdin" using ($1+(5.5*3600)):2 with linespoints pt 7 ps .3'
}

function vdisplay-destroy() {
    swaymsg -t get_outputs | jq -r .[].name | grep HEADLESS \
    | xargs -I{} swaymsg output {} unplug
}

function vdisplay() {
    HEADLESS=$(swaymsg -t get_outputs | jq -r .[].name | grep HEADLESS)
    if [ -z $HEADLESS ]; then
        swaymsg create_output
        HEADLESS=$(swaymsg -t get_outputs | jq -r .[].name | grep HEADLESS)
        swaymsg output $HEADLESS resolution 1280x720
        swaymsg output $HEADLESS bg "#404040" solid_color
        #swaymsg workspace 0 output $HEADLESS
        #swaymsg bindsym Mod4+grave workspace number 0
        #swaymsg bindsym Mod4+Shift+grave move container to workspace number 0
    fi
    wl-mirror -s e $HEADLESS
}

function cdj() {
    cd ~/decimal/*/*/${1}* || cd ~/decimal/*/*/*/${1}*
}

function urlencode() {
	python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$1"
}

function urldecode() {
	python3 -c 'import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))' "$1"
}

PATH="/home/hanifanazka/perl5/bin${PATH:+:${PATH}}"; export PATH;
PATH="$PATH:/usr/bin/vendor_perl/";
PERL5LIB="/home/hanifanazka/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/hanifanazka/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/hanifanazka/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/hanifanazka/perl5"; export PERL_MM_OPT;
PATH="$PATH:/var/lib/flatpak/exports/bin"
PATH="$PATH:/home/hanifanazka/go/bin"

function blender-intel-workaround() {
	echo 10000 | sudo tee /sys/class/drm/card1/engine/rcs0/preempt_timeout_ms
	INTEL_DEBUG=reemit blender
}


# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/home/hanifanazka/.cache/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

whitelist=("foot")
terminal_emulator=$(ps -o ppid= -p $$ | xargs ps -o cmd= -p)

if command -v theme.sh > /dev/null &&
	[[ "${whitelist[@]}" =~ $terminal_emulator.* ]];
then
    # open the light / dark theme based on darkman
    source ~/.terminal_scheme
    # open the last theme
    # [ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"

    # Optional

    #Binds C-o to the previously active theme.
    bind -x '"\C-o":"theme.sh $(theme.sh -l|tail -n2|head -n1)"'

    # alias th='theme.sh -i'

    # # Interactively load a light theme
    # alias thl='theme.sh --light -i'

    # # Interactively load a dark theme
    # alias thd='theme.sh --dark -i'
fi

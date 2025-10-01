# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# colored manual page
function man() {
    LESS_TERMCAP_mb=$'\e[1;34m'   \
    LESS_TERMCAP_md=$'\e[1;32m'   \
    LESS_TERMCAP_so=$'\e[1;33m'   \
    LESS_TERMCAP_us=$'\e[1;4;31m' \
    LESS_TERMCAP_me=$'\e[0m'      \
    LESS_TERMCAP_se=$'\e[0m'      \
    LESS_TERMCAP_ue=$'\e[0m'      \
    command man "$@"
}


function find_replace_in_file() {
	nr_args=$#
	
	if [[ $nr_args -ne 3 ]] ; then
		echo "ERR: Invalid number of arguments"
		echo "Expect the OLDTEXT, the NEWTEXT and the path to the file"
		return 1
	fi

	old=$1
	new=$2
	file=$3
	sed -i 's/$old/$new/g' $file
}



function find_replace_text_to_stdout() {
    nr_args=$#

    if [[ $nr_args -lt 2 || $nr_args -gt 3 ]] ; then
        echo "ERR: Invalid number of arguments"
        echo "Expect the OLDTEXT, the NEWTEXT, and optionally the path to the file"
        return 1
    fi

    old=$1
    new=$2

    if [[ $nr_args -eq 3 ]] ; then
        file=$3
        sed "s/$old/$new/g" "$file"
    else
        # works withe pipes, example: `cat in.txt | sed old new`
        sed "s/$old/$new/g"
    fi
}


function diacritics_replaced_with_ENG_letters() {
	nr_args=$#
	func_name=${FUNCNAME[0]}

	if [[ $nr_args != 1 ]] ; then
		echo "ERR: The script expects a file as argument." >&2
		echo "Example: $ $func_name file" >&2
		return 1   # DON'T use 'exit'
	fi


	file=$1

	if [[ ! -f $file ]] ; then
		echo "ERR: The argument <$file> is not a file." >&2
		return 1   # DON'T use 'exit'
	fi


	sed -i -E 's/[ĂÂ]/A/g' $file   # ['Ă', 'Â'] -> 'A'
	sed -i -E 's/[ăâ]/a/g' $file   # ['ă', 'â'] -> 'a'

	sed -i 's/Î/I/g' $file	 # 'Î' -> I
	sed -i 's/î/i/g' $file   # 'î' -> i

	sed -i 's/Ș/S/g' $file   # 'Ș' -> S
	sed -i 's/ș/s/g' $file   # 'ș' -> 's'

	sed -i 's/Ț/T/g' $file   # 'Ț' -> 'T'
	sed -i 's/ț/t/g' $file   # 'ț' -> 't'
}


alias ga='git add'
alias gc='git commit'
alias gp='git push'

alias copy='xclip -selection clipboard'
alias ip='ip -c'

alias nano='nano --linenumbers --mouse --tabsize=4'



# Prompt:
eval "$(oh-my-posh init bash --config $HOME/.cache/oh-my-posh/themes/stelbent.minimal.omp.json)"

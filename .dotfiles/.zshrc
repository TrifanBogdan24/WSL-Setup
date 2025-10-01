# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="xiong-chiamiov-plus"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)


# install Zsh Plugin Manager
source ~/.config/zsh/zpm/zpm.zsh 2>/dev/null || {
  git clone https://github.com/zpm-zsh/zpm ~/.config/zsh/zpm 2>/dev/null
  source ~/.config/zsh/zpm 2>/dev/null
}


### 3party plugins
zpm load                      \
  zpm-zsh/core-config         \
  zpm-zsh/ignored-users,async \
  zpm-zsh/check-deps,async    \
  zpm-zsh/ls,async            \
  zpm-zsh/colorize,async      \
  zpm-zsh/ssh,async           \
  zpm-zsh/dot,async           \
  zpm-zsh/undollar,async      \
  zpm-zsh/bookmarks,async     \
  voronkovich/gitignore.plugin.zsh,async     \
  zpm-zsh/autoenv,async                      \
  mdumitru/fancy-ctrl-z,async                \
  zpm-zsh/zsh-history-substring-search,async \
  zsh-users/zsh-autosuggestions,async        \
  zpm-zsh/fast-syntax-highlighting,async     \
  zpm-zsh/history-search-multi-word,async




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

alias ip='ip -c'

alias nano='nano --linenumbers --mouse --tabsize=4'

# Prompt:
eval "$(oh-my-posh init zsh --config $HOME/.cache/oh-my-posh/themes/tiwahu.omp.json)"

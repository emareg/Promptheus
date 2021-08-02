# Promptheus v.3.0 for bash, zsh, sh, ksh, dash


# check shell version

THISSHELL="$(ps -o comm= -p $$)"; THISVERSION=""; THISDATE="$(date '+%F %R')"
if [ -n "${BASH_VERSION}" ]; then THISSHELL="bash"; THISVERSION="${BASH_VERSION}"; fi
if [ -n "${ZSH_VERSION}" ]; then THISSHELL="zsh"; THISVERSION="${ZSH_VERSION}"; fi
if [ -n "${KSH_VERSION}" ]; then THISSHELL="ksh"; THISVERSION="${KSH_VERSION}"; fi
if [ -n "${POSH_VERSION}" ]; then THISSHELL="posh"; THISVERSION="${POSH_VERSION}"; fi  # no alias


# /a

# Colors
# --------------------------------->
ESC=$(printf "\e")


# Prompt Colors for sh/ksh/dash
white='\033[0;37m'; WHITE='\033[1;37m'
blue='\033[0;34m';   BLUE='\033[1;34m'
green='\033[0;32m'; GREEN='\033[1;32m'
cyan='\033[0;36m';   CYAN='\033[1;36m'
red='\033[0;31m';     RED='\033[1;31m'
purple='\033[0;35m'; PURPLE='\033[1;35m'
yellow='\033[0;33m'; YELLOW='\033[1;33m'
GRAY='\033[1;30m';   none='\033[0;30m'


white=$(printf "\e[0;37m"); WHITE=$(printf "\e[1;37m")
blue=$(printf "\e[0;34m");   BLUE=$(printf "\e[1;34m")
green=$(printf "\e[0;32m"); GREEN=$(printf "\e[1;32m")
cyan=$(printf "\e[0;36m");   CYAN=$(printf "\e[1;36m")
red=$(printf "\e[0;31m");     RED=$(printf "\e[1;31m")
purple=$(printf "\e[0;35m"); PURPLE=$(printf "\e[1;35m")
yellow=$(printf "\e[0;33m"); YELLOW=$(printf "\e[1;33m")
GRAY=$(printf "\e[1;30m");   none=$(printf "\e[0;30m")


# Prompt Colors: bash and zsh need special escapes...
	  # white='\001\033[0;37m\002'; WHITE='\001\033[1;37m\002'
	  # blue='\001\033[0;34m\002'; BLUE='\001\033[1;34m\002'
	  # green='\001\033[0;32m\002'; GREEN='\001\033[1;32m\002'
	  # cyan='\001\033[0;36m\002'; CYAN='\001\033[1;36m\002'
	  # red='\001\033[0;31m\002'; RED='\001\033[1;31m\002'
	  # purple='\001\033[0;35m\002'; PURPLE='\001\033[1;35m\002'
	  # yellow='\001\033[0;33m\002'; YELLOW='\001\033[1;33m\002'
	  # GRAY='\001\033[1;30m\002'
if [ "$THISSHELL" = "bash" ]; then
  white=$(printf "\001\e[0;37m\002"); WHITE=$(printf "\001\e[1;37m\002")
  blue=$(printf "\001\e[0;34m\002");   BLUE=$(printf "\001\e[1;34m\002")
  green=$(printf "\001\e[0;32m\002"); GREEN=$(printf "\001\e[1;32m\002")
  cyan=$(printf "\001\e[0;36m\002");   CYAN=$(printf "\001\e[1;36m\002")
  red=$(printf "\001\e[0;31m\002");     RED=$(printf "\001\e[1;31m\002")
  purple=$(printf "\001\e[0;35m\002"); PURPLE=$(printf "\001\e[1;35m\002")
  yellow=$(printf "\001\e[0;33m\002"); YELLOW=$(printf "\001\e[1;33m\002")
  GRAY=$(printf "\001\e[1;30m\002");   none=$(printf "\001\e[0;30m\002")
elif [ "$THISSHELL" = "zsh" ]; then
  # print -P '%B%F{red}co%F{green}lo%F{blue}rs%f%b'
  white="%{$fg_no_bold[white]%}"; WHITE="%{$fg_bold[white]%}"
  blue="%{$fg_no_bold[blue]%}"; BLUE="%{$fg_bold[blue]%}"
  green="%{$fg_no_bold[green]%}"; GREEN="%{$fg_bold[green]%}"
  cyan="%{$fg_no_bold[cyan]%}"; CYAN="%{$fg_bold[cyan]%}"
  red="%{$fg_no_bold[red]%}"; RED="%{$fg_bold[red]%}"
  purple="%{$fg_no_bold[magenta]%}"; PURPLE="%{$fg_bold[magenta]%}"
  yellow="%{$fg_no_bold[yellow]%}"; YELLOW="%{$fg_bold[yellow]%}"
  GRAY="%{$fg_bold[black]%}"
fi


## promptheus color settings
ptScolors(){
	_ptCn="$white"      # normal color
	_ptCpt="$cyan"      # color for Promptheus elements
	_ptChl="$YELLOW"    # color for higlighting symbols
	_ptCadd="$white"    # color for higlighting symbols
	_ptCgood="$green"    # color for higlighting symbols
	_ptCbad="$red"    # color for higlighting symbols
}
ptSnocolors(){
	_ptCn="";   _ptCpt="";   _ptChl="" 
	_ptCadd=""; _ptCgood=""; _ptCbad=""
}
ptScolors    # use colors by default


## dircolors (set LS_COLORS)
if [ -f ~/.dircolors ]; then
	eval "$(dircolors -b ~/.dircolors)"
else
	eval "$(dircolors -b ~/.promptheus/.dircolors)" 
fi




# check hostname and connection
# --------------------------------->

[ -z "$HOSTNAME" ] && HOSTNAME=$(hostname)

if [ -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY" ] ; then
    if [ -n "$DISPLAY" ]; then ptCat="$_ptCgood"; else ptCat="$_ptChl"; fi  # check X11
    ptPhost="${USER}${ptCat}@${_ptCpt}${HOSTNAME}${_ptChl}:${_ptCpt}"
else
    ptPhost=""
fi



# Source files
# --------------------------------->

# Welcome Message
[ -f ~/.promptheus/ptlogo ] && . ~/.promptheus/ptlogo

# Alias
[ -f ~/.promptheus/ptalias ] && . ~/.promptheus/ptalias





# Define Prompt
# --------------------------------->

## Prompt
_ptVoldPS1="$PS1"   # store old prompt
_PTMARK='>'         # shell user marker

__ptFsetvars(){
	ptVret=$?
	ptPtime="$(date '+%R')"
	# ptPtime=$(printf '%b' "$ptCtime$ptPtime$_ptCpt")  # bash bug: \033 followd by number...
	if [ $ptVret -ne 0 ]; then ptPerr="${_ptCbad}ERROR ${ptVret}\n${_ptCpt}"; else ptPerr=""; fi

	# PWD
	if [ "${ptVlwd}" != "$PWD" ]; then
		# echo "calc new pwd!"
  		ptPcwd=$(pwd|sed -e "s!$HOME!~!"| sed -re "s!/([^/]{12})[^/]{12,}!/\1…!g")
  		if [ -w "$(pwd)" ]; then ptCcwd="${_ptCgood}"; else ptCcwd="${_ptCpt}"; fi
		ptPcwdl="${ptCcwd}"$(printf '%b' "${ptPcwd}${_ptCpt}"  | sed "s/\//$(printf '%b' "$_ptChl\/$ptCcwd")/g")
		ptPcwds="${ptCcwd}"$(printf '%b' "${ptPcwd}" | sed -re "s!([^/]{2})[^/]{2,}+/!\1…/!g" | sed "s!…/!$(printf '%b' "$_ptChl…$ptCcwd")!g" | sed "s!/!$(printf '%b' "$_ptChl/$ptCcwd")!g")"${_ptCpt}"
		# ptPcwds="${ptCcwd}"$(printf '%b' "${ptPcwd}" | sed -re "s!([^/]{2})[^/]{2,}+/!\1…/!g" | sed "s!/!$(printf '%b' "$_ptChl/$ptCcwd")!g")"${_ptCpt}"
	fi

	# sleeping/running jobs
	if type "jobs" > /dev/null; then
		ptPjc="$(jobs | wc -l)"; 
		ptPj="${_ptCpt}[$_ptChl$ptPjc&$_ptCpt]"
		[ "$ptPjc" = "0" ] && ptPj=""
	fi

	# Python venv
	ptPvenv=""
	if [ -n "$VIRTUAL_ENV" ]; then
		ptPvenv="${_ptCadd}[`basename \"$VIRTUAL_ENV\"`]"
  	fi

	# git
	ptVisgit=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	ptPgit=""
	if [ "$ptVisgit" = "true" ]; then 
		ptPgit=$(printf '%b' "${_ptCadd} ⑂`git rev-parse --abbrev-ref HEAD`${_ptCn}");

    	ptPgitahead=$(git log --oneline "@{upstream}".. 2> /dev/null | wc -l | tr -d ' ')
    	ptPgitbehind=$(git log --oneline .."@{upstream}" 2> /dev/null | wc -l | tr -d ' ')
    	if [ "$ptPgitahead" != "0" ]; then 
    		ptPgit="$ptPgit$_ptChl↑$ptPgitahead"  # ahead
    	elif [ "$ptPgitbehind" != "0" ]; then
    		ptPgit="$ptPgit$_ptChl↓$ptPgitbehind" # behind
    	fi
    	ptPgitcom=$(git status --porcelain | grep '^ \?A\|^ \?M' | wc -l)
    	if test "$ptPgitcom" != "0"; then ptPgit="$ptPgit$_ptChl+"; fi    # non commited 

		ptPgitunt=$(git status --porcelain | grep '^??' | wc -l)
		if test "$ptPgitunt" != "0"; then ptPgit="$ptPgit$_ptCbad…"; fi  # untracked
	fi
	if [ "$(id -u)" -eq 0 ]; then ptPsign=$(printf '%s' " ${_ptCbad}#${_ptCn}"); else ptPsign=$(printf '%s' " ${_ptChl}${_PTMARK}${_ptCn}"); fi
}



# Print Prompt
# --------------------------------->

__ptPSfull(){
	__ptFsetvars
	PS1="${ptPerr}${_ptCpt}┌─${ptPj}─╸${ptPtime}╺─◆─┤ ${ptPhost}${ptPcwdl} ├─■
${_ptCpt}└─┤$ptPgit$ptPsign " 
	PS2="${_ptCpt}└◆┤ ${_ptCn}"
	ptVlwd="$PWD"
	#unset _ptCn _ptCpt
}

__ptPSslim(){
	__ptFsetvars
	ptPgit=$(echo $ptPgit|sed -re "s!master!!g")
	PS1="${ptPerr}${ptPvenv}${_ptCpt}${ptPj}${ptPcwds}${ptPgit}${ptPsign} "
}


# Define Settings for Shells
# --------------------------------->


if [ "$THISSHELL" = "zsh" ]; then
	_PTMARK='%%'
	ptSfull(){ precmd(){ __ptPSfull; }; }
	ptSslim(){ precmd(){ __ptPSslim; }; }

	# zsh specific options
	setopt autocd     # just dirname to cd

elif [ "$THISSHELL" = "bash" ]; then
	_PTMARK='$'
    ptSfull(){ PROMPT_COMMAND=__ptPSfull; }
    ptSslim(){ PROMPT_COMMAND=__ptPSslim; }

    # bash options
	shopt -s cdspell    # fix dir-name typos in cd
	shopt -s autocd     # cd to dirname

  	complete -cf sudo   # Bash sudo completion
  	# complete -o nospace -o filenames -F fuzzypath cd ls cat
else
	_PTMARK='>'
	ptSfull(){ export PS1='$(__ptPSfull; printf "$PS1")'; }
	ptSslim(){ export PS1='$(__ptPSslim; printf "$PS1")'; }
	ptSoff(){ export PS1="_ptVoldPS1"; }
fi

ptSslim










# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Own Functions
# ============================================================


# todo
# https://superuser.com/questions/561451/is-there-a-shell-which-supports-fuzzy-completion-as-in-sublime-text
# fuzzypath() {
#     if [ -z $2 ]; then
#         COMPREPLY=( `\ls | tr "\n" " "` )
#     else
#     	if [ ${2:0:1} == '$' ]; then COMPREPLY=""; return 1; fi
#     	DIRPATH=$(echo "$2" | sed -E 's/[^/]*$//')
#     	#echo $DIRPATH
#     	BASENAME=$(echo "$2")
#     	echo "BN:'"$BASENAME"'"
#         FILTER=$(echo "$BASENAME" | sed -E 's|.|\0.*|g')
#         COMPREPLY=(`\ls $DIRPATH | \grep -i "^$FILTER" | tr "\n" " " `)
#         echo ${COMPREPLY[@]}
#         # echo $(\ls -m | \grep -i "^D.*o.*" | sed -E "s|^||g")
#     fi
# }


ipscan(){
  local theip=$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')
  local ipbase="${theip%.*}."
  #echo $(seq 254) | xargs -P255 -I% -d" " ping -W 2 -c 1 ${ipbase}% | grep -E "[0-1].*?:"
  for i in {1..254} ;do (sleep 0.02; ping $ipbase$i -c 1 -W 2 | grep -E "[0-1].*?:" &) ;done; sleep 1
}


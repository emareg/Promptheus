
# check if interactive
if($?prompt) then


# aliases
alias .. 'cd ..'; alias ... 'cd ../..'; alias .... 'cd ../../..'
alias cd.. 'cd ..'

alias ls '\ls -BCF --color=always --group-directories-first'
alias sl '\ls'
alias ll '\ls -lGah --color --time-style=+"%y-%m-%d %R"'



# Colors!
set     red="%{\033[1;31m%}"
set   green="%{\033[0;32m%}"
set  yellow="%{\033[1;33m%}"
set    blue="%{\033[1;34m%}"
set magenta="%{\033[1;35m%}"
set    cyan="%{\033[0;36m%}"
set   white="%{\033[0;37m%}"
set   gray="%{\033[1;30m%}"
set     end="%{\033[0m%}" # This is needed at the end... :(


# Basic git information
#alias gitinfo 'set isgit=`git rev-parse --is-inside-work-tree`;if ("$isgit" == "true") git rev-parse --abbrev-ref HEAD'
alias gitinfo 'if (-d ".git") git rev-parse --abbrev-ref HEAD'


# if (-f ~/.dircolors) then
# 	#eval "`dircolors -c ~/.dircolors`"
# else
# 	dircolors -c ~/.promptheus/.dircolors
# endif


printf "   \033[0;33m \
  ██     ██  ███     ██  ███  ███     ███ \
  ██     ██  ██ ██   ██         ███ ███   \
  ██     ██  ██  ██  ██  ███      ███     \
  ██     ██  ██   ██ ██  ███    ███ ███   \
  █████████  ██     ███  ███  ███     ███ \
\033[0;37m                                \
  Where there is a shell, there is a way. \
"


# check connection
if ($?SSH_CLIENT || $?SSH2_CLIENT || $?SSH_TTY) then
	set HOST_INFO="`id -u -n`@`hostname`"
else 
	set HOST_INFO="`id -u -n`"
endif


if ($?tcsh) then
	setenv THISSHELL "tcsh"


	alias precmd 'set prompt="%?\n${cyan}┌─╸`date +%R`╺─◆─┤ ${white}%c05${cyan} ├─■\n└─┤${HOST_INFO} ${gray}`gitinfo`${end}%# "'


else
	setenv THISSHELL="csh"

	echo "  This is only C-Shell (CSH). Good Luck."
	echo ""

    alias setprompt 'set prompt="`pwd` `gitinfo`)"'
    #alias setprompt 'set prompt="┌─╸`date +%R`╺─◆─┤`pwd`├─■└─┤${HOST_INFO}`gitinfo`%# "'
    setprompt
    alias cd 'chdir \!* && setprompt'
endif



endif
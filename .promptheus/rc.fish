# Promptheus v.3.0 fish theme

# be consistent with other shells
set -g HOSTNAME (hostname)


# startup message
function fish_greeting
	set -gx THISVERSION $FISH_VERSION
	set -gx THISSHELL "fish"
	set THISDATE (date "+%F %R")

	# show logo
	source ~/.promptheus/ptlogo
end


# Aliases
source ~/.promptheus/ptalias


# Color Settings
# =====================================================

# fish colors
set fish_color_command green   # color of correct command
set fish_color_param cyan      # color of file name parameters


# promptheus colors
set	_ptCn  (set_color white)    # normal color
set	_ptCpt (set_color cyan)     # primary promptheus color
set	_ptChl (set_color bryellow) # color for higlighting symbols
set	_ptCadd (set_color grey)  # color for additional info
set	_ptCgood (set_color green)   
set	_ptCbad (set_color red)   


# set dircolors
if test -f ~/.dircolors
	set -gx LS_COLORS (dircolors -c ~/.dircolors | string split ' ')[3]
else
	set -gx LS_COLORS (dircolors -c ~/.promptheus/.dircolors | string split ' ')[3]
end
if string match -qr '^([\'"]).*\1$' -- $LS_COLORS
	set LS_COLORS (string match -r '^.(.*).$' $LS_COLORS)[2]
end



# set hostname
set -g _ptPhost ""

if set -q SSH_TTY
  set -g _ptPhost "$USER$_ptChl@$_ptCpt$HOSTNAME$_ptChl:$_ptCpt"
end




# prompt
# =====================================================
set fish_prompt_pwd_dir_length 0   # deactivate fish length


function __ptFsetvars
	
	set -l res $status
	# check status & print error code
	if test $res -ne 0
		echo $_ptCbad"ERROR $res$_ptCpt"
	end 

	# Time
	set -g ptPtime (date '+%R')

	# PWD
	if test "$_ptVlwd" != "$PWD"
  		set ptVcwd (prompt_pwd)
  		if test -w $PWD
  			set ptCcwd $_ptCgood
  		else 
  			set ptCcwd $_ptCpt
  		end

		# shorten path
		set ptVcwd (echo "$ptVcwd" |sed -re 's!/([^/]{10})[^/]{8,}$!/\1…!g')

		# colorize
		set -g ptPcwd "$ptCcwd"(echo "$ptVcwd" |sed "s!/!$_ptChl/$ptCcwd!g")"$_ptCpt"
	end


	# sleeping/running jobs
	set -g ptPj "["(jobs | wc -l)"&]"
	if test "$ptPj" = "[0&]"; set ptPj ""; end

	# git
	set -g ptPgit (git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [ $ptPgit ]
		set ptPgit " $_ptCadd⑂$ptPgit$_ptCn"

    	set ptPgitahead (git log --oneline "@{upstream}".. 2> /dev/null | wc -l | tr -d ' ')   # ⇡⇑↑↟
    	set ptPgitbehind (git log --oneline .."@{upstream}" 2> /dev/null | wc -l | tr -d ' ')
    	if test $ptPgitahead != "0"; 
    		set ptPgit "$ptPgit$_ptChl↑$ptPgitahead"  # ahead
    	else if test $ptPgitbehind != "0"
    		set ptPgit "$ptPgit$_ptChl↓$ptPgitbehind" # behind
    	else
    		# set ptPgit "$ptPgit$_ptCgood=" # equal
    		set ptPgit "$ptPgit" # equal
    	end 

		set ptPgitcom (git status --porcelain | grep '^ \?A\|^ \?M' | wc -l)
    	# if test $ptPgitcom != "0"; set ptPgit "$ptPgit$_ptChl+$ptPgitcom"; end    # non commited 
    	if test $ptPgitcom != "0"; set ptPgit "$ptPgit$_ptChl+"; end    # non commited 

		set ptPgitunt (git status --porcelain | grep '^??' | wc -l)
		if test $ptPgitunt != "0"; set ptPgit "$ptPgit$_ptCbad…"; end  # untracked
	end

	# user sign
	if test $USER = "root"
		set -g ptPsign "$_ptCbad#$_ptCn"
	else 
		set -g ptPsign "$_ptChl§$_ptCn"
	end
end


function __ptPtwoline
	__ptFsetvars
	echo "$_ptCpt┌──╸$ptPtime╺─◆─┤ $_ptPhost$ptPcwd ├─■"\n"$_ptCpt└─$ptPj┤$ptPgit $ptPsign "
	set -g _ptVlwd "$PWD"  # store last CWD
end


function __ptPoneline
	__ptFsetvars

    set -l ptPcwd (echo $ptPcwd|sed -re "s!([^/]{6})[^/]{8,}/!\1$_ptChl…!g")   # further shrink cwd
    set -l ptPgit (echo $ptPgit|sed -re "s!master!!g")

    echo "$_ptCpt$ptPj$ptPcwd$ptPgit $ptPsign "
    set -g _ptVlwd "$PWD"  # store last CWD
end



## define setting functions
function ptSfull; function fish_prompt; __ptPtwoline; end; end
function ptSslim; function fish_prompt; __ptPoneline; end; end
function ptSoff; function fish_prompt; echo -n -s (set_color $fish_color_user)"$USER:"(set_color $fish_color_cwd)(prompt_pwd)" > "
end; end



# finally set default theme
ptSslim



function sysinfo; ~/.promptheus/scripts/sysinfo.sh; end
function extract; ~/.promptheus/scripts/extract.sh; end
function help; source ~/.promptheus/pthelp; end

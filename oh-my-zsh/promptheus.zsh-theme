# Promptheus ZSH Theme


# colors
local main_color="%{$fg_no_bold[cyan]%}";
local emph_color="%{$fg_bold[yellow]%}";
local pos_color="%{$fg_bold[green]%}";
local neg_color="%{$fg_bold[red]%}";


local return_code="%(?..${neg_color}%? ↵%{$reset_color%})"


function colorpath(){
  wdir=$(pwd)
  wdir=${wdir/#$HOME/\~}
  [ -w $(pwd) ] && path_color="${pos_color}" || path_color="${main_color}"
  echo "${wdir//\//${emph_color}/${path_color}}"
}


if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]%}${neg_color}%n'
else
    local user_host='%{$terminfo[bold]%}${main_color}%n'
fi
if [[ -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY" ]] ; then
    # If we are connected with a X11 support
    if [[ -n "$DISPLAY" ]] ; then
      user_host+="${pos_color}@%{$reset_color%}%m"
    else
      user_host+="%{$reset_color%}@%m"
    fi
else
	user_host+="%{$reset_color%}"
fi




local current_dir='%{$terminfo[bold]%}%~%{$reset_color%}'
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="${main_color}┌─╸%T╺─◆─┤ ${current_dir} ${rvm_ruby}${git_branch}${main_color}├─■
└─┤${user_host}${emph_color}$%b "
RPS1='$(vi_mode_prompt_info) ${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "


alias ff='find . | grep -i'    # find file
alias fa='grep -InH -r'        # find all


PROMPT='$FG[237]${(l.COLUMNS..-.)}%{$reset_color%}
${return_status} %{$fg[yellow]%}$(get_pwd)%{$reset_color%} $(git_prompt_info)${prompt_suffix}'
# λπ
local return_status="%(?:%{$fg_bold[cyan]%}π:%{$fg_bold[red]%}π)"

local prompt_suffix="%{$fg[magenta]%}»%{$reset_color%} "

# by shashankmehta (https://github.com/shashankmehta)
function get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%2~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

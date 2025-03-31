# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/bndo/.mujoco/mujoco200/bin
# export TERM="xterm-256color"
export TERMINAL="terminator"
export BROWSER="firefox"
export READER="zathura"
export FILE="vu"
ZSH=$HOME/.oh-my-zsh

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed

[ ! -d ~/.zplug ] && echo "---------zplug---------" && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh
[ ! -d ~/.zplug/repos/zsh-users ] && mkdir -p ~/.zplug/repos/zsh-users
[ ! -d ~/.zplug/repos/plugins ] && mkdir -p ~/.zplug/repos/plugins

# Syntax highlighting and tab completion
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# [ ! -d  ~/.zplug/repos/zsh-users/zsh-syntax-highlighting ] && echo "---------zsh-syntax---------" && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zplug/repos/zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
# oh-my-zsh

# Miscellaneous commands


# zplug "plugins/common-aliases",    from:oh-my-zsh
# Supports oh-my-zsh plugins and the like
# [ ! -d  ~/.zplug/repos/zsh-users/zsh-completions ] && echo "---------zsh-completions---------" && git clone https://github.com/zsh-users/zsh-completions.git ~/.zplug/repos/zsh-users/zsh-completions
zplug "zsh-users/zsh-completions"
# [ ! -d ~/.zplug/repos/zsh-users/zsh-autosuggestions ] && echo "---------zsh-autosuggestions---------" && git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zplug/repos/zsh-users/zsh-autosuggestions
zplug "zsh-users/zsh-autosuggestions"
# zsh-syntax-highlighting must be loaded after executing compinit command
# and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# [ ! -d ~/.zplug/repos/plugins/colored-man-pages ] && git clone https://github.com/ael-code/zsh-colored-man-pages.git ~/.zplug/repos/plugins/colored-man-pages
zplug "plugins/colored-man-pages", from:oh-my-zsh
# =============================================================================
#                                   Options
# =============================================================================

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
setopt hist_ignore_space        # Ignore commands that start with space.

# Changing directories
#setopt auto_pushd
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".

setopt extended_glob

zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

# =============================================================================
#                                Key Bindings
# =============================================================================

# # Common CTRL bindings.
# bindkey "^a" beginning-of-line
# bindkey "^e" end-of-line
# bindkey "^f" forward-char
# bindkey "^b" backward-char
# bindkey "^k" kill-line
# bindkey "^d" delete-char
# # bindkey "^y" accept-and-hold
bindkey "^[h" backward-kill-word
# # bindkey "^u" backward-kill-line
# # bindkey "^R" history-incremental-pattern-search-backward
# # bindkey "^F" history-incremental-pattern-search-forward

# # Do not require a space when attempting to tab-complete.
# bindkey "^i" expand-or-complete-prefix

# # Fixes for alt-backspace and arrows keys
# bindkey '^[^?' backward-kill-word
# bindkey "^[[1;5C" forward-word
# bindkey "^[[1;5D" backward-word
# #bindkey "^[[C" forward-word
# #bindkey "^[[D" backward-word
# # bindkey "^[d" kill-word
# # bindkey "^[^h" backward-kill-word
# ## Emulate tcsh's backward-delete-word
# #tcsh-backward-kill-word () {
# #    local WORDCHARS="${WORDCHARS:s#/#}"
# #    zle backward-kill-word
# #}
# #zle -N tcsh-backward-kill-word

# # https://github.com/sickill/dotfiles/blob/master/.zsh.d/key-bindings.zsh
# tcsh-backward-word () {
#   local WORDCHARS="${WORDCHARS:s#./#}"
#   zle emacs-backward-word
# }
# zle -N tcsh-backward-word
# bindkey '\e[1;3D' tcsh-backward-word
# bindkey '\e^[[D' tcsh-backward-word # tmux

# tcsh-forward-word () {
#   local WORDCHARS="${WORDCHARS:s#./#}"
#   zle emacs-forward-word
# }
# zle -N tcsh-forward-word
# bindkey '\e[1;3C' tcsh-forward-word
# bindkey '\e^[[C' tcsh-backward-word # tmux
# bindkey '^[f' tcsh-forward-word
# bindkey '^[b' tcsh-backward-word

# tcsh-backward-delete-word () {
#   local WORDCHARS="${WORDCHARS:s#./#}"
#   zle backward-delete-word
# }
# zle -N tcsh-backward-delete-word
# bindkey "^[^?" tcsh-backward-delete-word # urxvt
# bindkey "^[^h" tcsh-backward-delete-word # urxvtkill-word

# tcsh-forward-delete-word () {
#   local WORDCHARS="${WORDCHARS:s#./#}"
#   zle delete-word
# }
# zle -N tcsh-forward-delete-word
# bindkey "^[d" tcsh-forward-delete-word
# =============================================================================
#                                 Completions
# =============================================================================

zstyle ':completion:*' rehash false
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# =============================================================================
#                                   Startup
# =============================================================================


# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    echo "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi


# # PROMPT
# Show OS info when opening a new terminal
# neofetch

# Font mode for powerlevel9k
#POWERLEVEL9K_MODE="nerdfont-complete"

# Set name of the theme to load.
# ZSH_THEME="sorin"
# ZSH_THEME="edvardm"
# ZSH_THEME="awesomepanda"
# ZSH_THEME="gozilla"
# ZSH_THEME="dracula"
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="instantos"
# ZSH_THEME="cloud"
# ZSH_THEME="af-magic"
# ZSH_THEME="afowler"
# ZSH_THEME="dpoggi"
# ZSH_THEME="suvash"
# ZSH_THEME="arrow"
# ZSH_THEME="avit"
# ZSH_THEME="typewritten"
# ZSH_THEME="dpoggi"
# ZSH_THEME="sorin"
# ZSH_THEME="afowler"
# ZSH_THEME="pi"

# Command execution time stamp shown in the history command output.
HIST_STAMPS="mm/dd/yyyy"

# Plugins to load
plugins=(git
        virtualenv)
source $ZSH/oh-my-zsh.sh



# Then, source plugins and add commands to $PATH
zplug load

#ZLE_RPROMPT_INDENT=0

# vim: ft=zsh
# =============================================================================
#                                   Aliases
# =============================================================================

# In the definitions below, you will see use of function definitions instead of
# aliases for some cases. We use this method to avoid expansion of the alias in
# combination with the globalias plugin.

# Generic command adaptations
alias grep='() { $(whence -p grep) --color=auto $@ }'
alias egrep='() { $(whence -p egrep) --color=auto $@ }'

# Custom helper aliases
alias rm='rm -v'

alias em1="emacsclient -s workspace1 -c"
alias em2="emacsclient -s workspace2 -c"
alias em3="emacsclient -s workspace3 -c"
alias em4="emacsclient -s workspace4 -c"
alias cat="batcat"
# alias ls='ls -l --color=always --group-directories-first --human-readable'
alias ip="ip -c"
# alias rm="rm -i"
alias x="ranger"

# Directory management
alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'
alias d='dirs -v'

alias doc='cd ~/Documents'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias backup='cd ~/Documents/backup'
alias dot='cd ~/Downloads/clones/dtdotfiles'
alias school='cd /run/media/bndo/USBschool'
alias labs='cd /run/media/bndo/USB/school/lab'
alias cours='cd /run/media/bndo/USB/school/cours'
alias cusb='cd /run/media/bndo/USB'
alias cmount='cd /run/media/bndo'

viman () { text=$(man "$@") && echo "$text" | vim -R +":set ft=man" - ; }

#for f in /etc/profile.d/*.sh; do
#    source $f
#done

# Auto cd

# Aliases
alias emax='emacsclient -s workspace1 -c -n'
# alias grep='grep --color=auto'
# alias pgrep='pgrep -ai'

export ALTERNATE_EDITOR=""
# export PATH=$PATH:/usr/local/avr

# autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
source ~/.zplug/repos/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
# zstyle ':bracketed-paste-magic' active-widgets '.self-*'

playtube () {
    mplayer -cookies -cookies-file /tmp/cook.txt $(youtube-dl -g --cookies /tmp/cook.txt "$1")
}

mntphone () {
    simple-mtpfs --device 1 ~/phone
}

umntphone () {
    fusermount -u ~/phone
}

yttomp3(){
    link=$1
    youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $link
}

ytdl(){
    link=$1
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' $link
}

pkgsearch () {
    pacman -Ss $1 | grep community | cut -d"/" -f 2 | cut -d" " -f 1
}

grep-finals () {
    curl -s https://www.polymtl.ca/etudes/cours/horaires-examens-controles | grep $1 -A 25
}

grep-excel () {
    xlsx2csv $1 | grep $2
}

ef() {
    fzf | xargs -r -I % $EDITOR % ;
}

goto() {
    cd $(cat ~/.config/bmdirs | fzf)
}

open() {
    nohup $1 $2 </dev/null >/dev/null 2>&1 &
}

compress_video () {
    ffmpeg -i $1 -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k -movflags +faststart -vf scale=-2:720,format=yuv420p $2
}

if [[ -n ${LAUNCHER} ]]; then
    bindkey -s "^M" " & \n"
    bindkey -s "^[" "^U exit \n"
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
setopt PROMPT_SUBST
# PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%2~\a" }

eval "$(direnv hook zsh)"

. "$HOME/.cargo/env"

[ -f "/home/bndo/.ghcup/env" ] && . "/home/bndo/.ghcup/env" # ghcup-env
bindkey -r "^G"

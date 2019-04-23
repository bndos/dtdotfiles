export TERM="xterm-256color"
export EDITOR="emax"
export TERMINAL="terminator"
export BROWSER="firefox"
export READER="zathura"
export FILE="vu"
ZSH=$HOME/.oh-my-zsh

# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5'

export ENHANCD_FILTER="fzf:peco:percol"
export ENHANCD_COMMAND='c'

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed

[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Syntax highlighting and tab completion
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zplug/repos/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit
# oh-my-zsh

# Miscellaneous commands
zplug "k4rthik/git-cal",  as:command
zplug "peco/peco",        as:command, from:gh-r
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf, \
use:"*${(L)$(uname -s)}*amd64*"
zplug "junegunn/fzf", use:"shell/*.zsh", as:plugin

# Simple zsh calculator
zplug "arzzen/calc.plugin.zsh"


# zplug "plugins/common-aliases",    from:oh-my-zsh
# Supports oh-my-zsh plugins and the like
if [[ $OSTYPE = (linux)* ]]; then
    zplug "plugins/archlinux",     from:oh-my-zsh, if:"(( $+commands[pacman] ))"
    zplug "plugins/dnf",           from:oh-my-zsh, if:"(( $+commands[dnf] ))"
fi

if [[ $OSTYPE = (darwin)* ]]; then
    zplug "lib/clipboard",         from:oh-my-zsh
    zplug "plugins/osx",           from:oh-my-zsh
    zplug "plugins/brew",          from:oh-my-zsh, if:"(( $+commands[brew] ))"
    zplug "plugins/macports",      from:oh-my-zsh, if:"(( $+commands[port] ))"
fi

zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
# zsh-syntax-highlighting must be loaded after executing compinit command
# and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "plugins/colored-man-pages", from:oh-my-zsh
# =============================================================================
#                                   Options
# =============================================================================

# improved less option
export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

# Key timeout and character sequences
KEYTIMEOUT=1
WORDCHARS='*?_-[]~=./&;!#$%^(){}<>'

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

zstyle ':completion:*' rehash true
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
    printf "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

if zplug check "zsh-users/zsh-history-substring-search"; then
	zmodload zsh/terminfo
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	bindkey "^[[1;5A" history-substring-search-up
	bindkey "^[[1;5B" history-substring-search-down
fi

if zplug check "zsh-users/zsh-syntax-highlighting"; then
	#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
	ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

	typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[cursor]='bg=yellow'
	ZSH_HIGHLIGHT_STYLES[globbing]='none'
	ZSH_HIGHLIGHT_STYLES[path]='fg=white'
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[command]='fg=green'
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
fi

# # PROMPT
# Show OS info when opening a new terminal
# neofetch

# Font mode for powerlevel9k
#POWERLEVEL9K_MODE="nerdfont-complete"

# Set name of the theme to load.
ZSH_THEME="sorin"

# Command auto-correction.
ENABLE_CORRECTION="true"

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

alias emacs="emacsclient -s workspace1 -t"
alias cat="bat"
alias cl="colorls"
alias ls='ls -l --color=always --group-directories-first --human-readable'
alias ls="lsd"
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
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias school='cd ~/Documents/poly'
alias tps='cd ~/Documents/poly-tps'

viman () { text=$(man "$@") && echo "$text" | vim -R +":set ft=man" - ; }

#for f in /etc/profile.d/*.sh; do
#    source $f
#done

# Auto cd

# Aliases
alias emax='emacsclient -c'
# alias grep='grep --color=auto'
# alias pgrep='pgrep -ai'

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode
# export PATH=$PATH:/usr/local/avr

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
source ~/.zplug/repos/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

playtube () {
	mplayer -cookies -cookies-file /tmp/cook.txt $(youtube-dl -g --cookies /tmp/cook.txt "$1")
}

mntphone () {
	simple-mtpfs --device 1 ~/phone
}

umntphone () {
	fusermount -u ~/phone
}

yt(){
    
    link=$1

    # link="https://youtu.be/YFD2PPAqNbw"
    musicName=`youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' $link --restrict-filenames --get-filename`
    echo $musicName

    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' $link --restrict-filenames

}

if [[ -n ${LAUNCHER} ]]; then
    bindkey -s "^M" " & \n"
    bindkey -s "^[" "^U exit \n"
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# If not running interactively, don't do anything
# [ -z "$PS1" ] && return

# make sure tab completion is working for apt and sudo
complete -cf sudo
complete -cf apt-get
complete -cf git

#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------
[ -f /etc/bashrc ] && source /etc/bashrc

#-------------------------------------------------------------
# add .bash_exports
#-------------------------------------------------------------
[ -f $HOME/.bash_exports ] && source $HOME/.bash_exports

#-------------------------------------------------------------
# add .bash_aliases
#-------------------------------------------------------------
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------
alias debug="set -o nounset; set -o xtrace"

ulimit -S -c 0      # Don't want coredumps.
set -o notify
set -o noclobber
set -o ignoreeof

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

PS1_string="\[\e[0;1m\]┌─[\[\e[32;1m\]\u\[\e[34;1m\]@\[\e[31;1m\]\H\[\e[0;1m\]:\[\e[33;1m\]\w\[\e[0;1m\]]"
#add git to ps1
if [ -f /etc/bash_completion.d/git-prompt ]; then
    . /etc/bash_completion.d/git-prompt
    PS1_string=$PS1_string"\$(__git_ps1)"
elif [ -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion.d/git
    PS1_string=$PS1_string"\$(__git_ps1)"
elif [ -f ~/.git-completion ]; then
    . ~/.git-completion
    PS1_string=$PS1_string"\$(__git_ps1)"
elif [ -f /opt/etc/bash_completion.d/git-prompt.sh ]; then
    . /opt/etc/bash_completion.d/git-prompt.sh
    PS1_string=$PS1_string"\$(__git_ps1)"
fi
PS1=$PS1_string"\n└→ \[\e[0m\]"

[ -f ~/.commacd.bash ] && source ~/.commacd.bash

if [[ "$-" == *i* ]]; then
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'

    # Base16 Shell
    BASE16_SHELL="$HOME/dotfiles/base16-shell/base16-ashes.dark.sh"
    [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
fi

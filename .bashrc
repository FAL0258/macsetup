#PATH
export PATH="$HOME/.cargo/bin:$HOME/go/bin/:/usr/local/sbin:$PATH"


#ls Directories in color
alias ls='ls -a $@'
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Git branch name 
#
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'

# Append to the history file, don't overwrite it
shopt -s histappend
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOR="\[\033[0m\]"

# Save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist

# Do not autocomplete when accidentally pressing Tab on an empty line. (It takes forever and yields "Display all 15 gazillion possibilites?")
shopt -s no_empty_cmd_completion

# No install emoji for brew
export HOMEBREW_NO_EMOJI=1

#Increase the size of history maintained by BASH - variables defined below increase the number of history items and history file size (default value is 500):
export HISTSIZE=10000

#Ensure syncing (flushing and reloading) of .bash_history with in-memory history:
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

#Use leading space to hide commands from history:
export HISTCONTROL=ignorespace

PS1="$GREEN\u@\h$NO_COLOR:\w$YELLOW\$(parse_git_branch)$NO_COLOR\$ "


# terminal title to working directory) #
#
PS1+="\[\033]0;\w\007\]"  


# Rbenv #
#
eval "$(rbenv init -)"


# Git completion #
#
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi


# npm completion #
#
if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi


# NVM #
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export NODE_EXTRA_CA_CERTS="/Users/fharper/Documents/configs/charles-ssl-proxying-certificate.pem"


# Aliases #
#
alias rm=trash


# CD into newly cloned folder automatically #
#
git()
{
   if [ "$1" = clone ] ; then
      /usr/local/bin/git "$@" && cd $(basename $_ .git)
      echo 'Changing directory to repo folder...'
   else
     /usr/local/bin/git "$@"
   fi
}

# Z #
#
. ~/z/z.sh

#JENV
eval "$(jenv init -)"

eval "$(pyenv init -)"
export PATH="$HOME/.cargo/bin:$PATH"eval "$(pyenv init -)"
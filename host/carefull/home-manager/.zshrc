# some of the options set here are copied over from:
# 1. https://github.com/radleylewis/zsh
# 2. https://github.com/rothgar/mastering-zsh

# see https://wiki.archlinux.org/title/Tmux#Start_tmux_on_every_shell_login
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s default >/dev/null 2>&1
fi

# see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html#cli-command-completion-linux
autoload bashcompinit && bashcompinit # this needed to load aws_completer
complete -C "aws_completer" aws # enable aws command completion

fpath+=($ZDOTDIR/completions) # add ~/.config/zsh/completions as one of completion sources
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # lowercase completion input matches upper and lower

# zoxide integration
eval "$(zoxide init zsh)"

HISTFILE="${HOME}/.config/zsh/history" # place command history file at ~/.config/zsh/history
HISTSIZE=100000
SAVEHIST=100000
ZSH_AUTOSUGGEST_HISTORY_IGNORE="([[:space:]]##*)" # don't put entered command prefixed with any space to history

# see https://github.com/rothgar/mastering-zsh/blob/master/docs/config/history.md#configuration
setopt APPEND_HISTORY            # append to history file
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_NO_STORE             # Don't store history commands
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.

setopt AUTOCD # cd without cd, e.x. cd Documents -> Documents
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

export EDITOR="nvim" # set default text editor to neovim
export VISUAL="nvim" # set default text editor to neovim
export K9S_SKIN="transparent" # set k9s background to transparent
export MANPAGER="bat -l man -p" # use bat as man pager
export BROWSER="xdg-open" # set default browser when pop-up from program

# auto generated from pnpm setup
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}' # fzf preview
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # Ctrl-T uses fd
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'" # Ctrl-T preview use bat

alias cc="claude"
alias dud="docker compose up --detach"
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gs="git status"
alias k9="k9s"
alias k="kubectl"
alias l="lsd -lAh"
alias ld="lazydocker"
alias lg="lazygit"
alias ls="lsd"
alias mk="make"
# alias npm="pnpm"
alias open="$BROWSER"
alias v="nvim"

# keybinding
bindkey -e # set text edit mode to emacs (default zsh)
bindkey "^ " autosuggest-accept # Ctrl + Space to accept suggestion
# zsh-history-substring-search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[[ -n "${ZSH_DEBUGRC+1}" ]] && zprof # end profiling

# NOTES:
# check truecolor: https://github.com/termstandard/colors

# see https://wiki.archlinux.org/title/Tmux#Start_tmux_on_every_shell_login
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s default >/dev/null 2>&1
fi

fpath+=($ZDOTDIR/completions) # add ~/.config/zsh/completions as one of completion sources

alias v="nvim"
alias mk="make"
alias l="lsd -lAh"
alias ls="lsd"
alias lg="lazygit"
alias k9="k9s"
alias k="kubectl"
alias y="yazi"
alias vs="warp-cli status"
alias vc="warp-cli connect"
alias vd="warp-cli disconnect"
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gs="git status"

EDITOR="nvim" # set default text editor to neovim
K9S_SKIN="transparent" # set k9s background to transparent
HISTFILE="${HOME}/.config/zsh/history" # place command history file at ~/.config/zsh/history
ZSH_AUTOSUGGEST_HISTORY_IGNORE="([[:space:]]##*)" # don't put entered command prefixed with any space to history

# auto generated from pnpm setup
export PNPM_HOME="/home/mirza/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# see https://github.com/rothgar/mastering-zsh/blob/master/docs/config/history.md#configuration
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

bindkey -e # set text edit mode to emacs (default zsh)
bindkey "^ " autosuggest-accept # Ctrl + Space to accept suggestion

[[ -n "${ZSH_DEBUGRC+1}" ]] && zprof # end profiling

# NOTES:
# check truecolor: https://github.com/termstandard/colors


# Think of porting these to sessionVariables key in home.nix
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export KEYTIMEOUT=1

export DOTFILES="$HOME/.dotfiles"

# export ZSH=~/.oh-my-zsh
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export FPATH="$HOME/.nix-profile/share/zsh/site-functions:$FPATH"

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export PATH="$HOME/.local/bin:$PATH"

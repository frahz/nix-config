
function in_nix_shell() {
    if [ ! -z ${IN_NIX_SHELL+x} ]; then
        echo " (nix)";
    fi
}

PROMPT='%{$fg[cyan]%}λ%{$reset_color%} %c $(git_prompt_info)%{$reset_color%}'
RPROMPT='%F{blue}%b$(in_nix_shell)%f %{$fg[magenta]%}[%m]%{reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

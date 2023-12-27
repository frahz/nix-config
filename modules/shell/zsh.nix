{ ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        ohMyZsh = {
            enable = true;
            plugins = [ "git" "tmux" ];
            theme = "lambda"; # change to my own theme later on
        };
        shellAliases = {
            vim = "nvim";
        };
    };
}

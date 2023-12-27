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

        };
        shellAliases = {
            vim = "nvim";
        };
    };
}

{...}:

{
    home.file.".oh-my-zsh/custom/themes/frahz.zsh-theme" = {
        source = ./frahz.zsh-theme;
    };

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;

        oh-my-zsh = {
            enable = true;
            plugins = [ "git" "tmux" ];
            theme = "frahz";
        };

        syntaxHighlighting = {
            enable = true;
        };

        shellAliases = {
            vim = "nvim";
        };

    };
}

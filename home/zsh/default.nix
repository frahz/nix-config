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
            custom = "$HOME/.oh-my-zsh/custom";
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

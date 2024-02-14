{ pkgs, ... }:

{
    programs.bat = {
        enable = true;
        config = {
            theme = "Catppuccin-mocha";
        };
        themes = let
            src = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "bat";
                rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
                hash = "";
            };
        in {
            Catppuccin-mocha = {
                inherit src;
                file = "Catppuccin-mocha.tmTheme";
            };
        };
    };
}

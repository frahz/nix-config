{ lib, pkgs, ... }:
let
  find = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = find;
    fileWidgetCommand = find;
    fileWidgetOptions = [ "--preview 'bat --plain --number --color=always {}'" ];
  };
  catppuccin.fzf.enable = true;
}

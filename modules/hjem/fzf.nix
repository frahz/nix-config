{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  find = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
  sources = config.catppuccin.sources;
in
{
  hjem.users.frahz = {
    packages = singleton pkgs.fzf;
    environment.sessionVariables = {
      FZF_CTRL_T_COMMAND = find;
      FZF_CTRL_T_OPTS = "--preview 'bat --plain --number --color=always {}'";
      FZF_DEFAULT_COMMAND = find;
      FZF_DEFAULT_OPTS_FILE = "${sources.fzf}/catppuccin-fzf-mocha.rc";
    };
  };
}

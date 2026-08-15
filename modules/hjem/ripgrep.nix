{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  user = config.hjem.users.frahz;
in
{
  hjem.users.frahz = {
    packages = singleton pkgs.ripgrep;
    environment.sessionVariables.RIPGREP_CONFIG_PATH = "${user.xdg.config.files."ripgrep/ripgreprc".source}";
    xdg.config.files."ripgrep/ripgreprc".text = ''
      --max-columns=150
      --max-columns-preview
      --glob=!.git/*
      --smart-case
    '';
  };
}

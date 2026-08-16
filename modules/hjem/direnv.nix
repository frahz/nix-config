{ lib, pkgs, ... }:
let
  inherit (lib.lists) singleton;
in
{
  hjem.users.frahz = {
    packages = singleton pkgs.direnv;
    extraDependencies = singleton pkgs.nix-direnv;
    environment.sessionVariables.DIRENV_LOG_FORMAT = "";
    xdg.config.files = {
      "direnv/direnv.toml" = {
        generator = (pkgs.formats.toml { }).generate "direnv.toml";
        value.global.hide_env_diff = true;
      };
      "direnv/direnvrc".text = ''
        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc

        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs

        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "$XDG_CACHE_HOME"/direnv/layouts/
            echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
          )}"
        }
      '';
    };
  };
}

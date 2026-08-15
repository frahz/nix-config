{ inputs', pkgs, ... }:
{
  hjem.users.frahz.packages = builtins.attrValues {
    inherit (pkgs)
      dig
      dix
      jq
      killall
      man-db
      unrar
      unzip
      ;

    nvim = inputs'.nvim-flake.packages.default;
  };
}

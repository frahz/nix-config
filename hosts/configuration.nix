{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../users/frahz
  ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      coreutils
      killall
      jq
      tokei
      wget
    ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  system.stateVersion = "23.11";
}

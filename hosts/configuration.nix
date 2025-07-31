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
      ripgrep
      binutils
      coreutils
      killall
      fd
      git
      btop
      jq
      neovim
      tokei
      wget
      tmux
    ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "23.11";
}

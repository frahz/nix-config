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
    ../modules/shell
  ];

  environment = {
    systemPackages = with pkgs; [
      bat
      ripgrep
      binutils
      coreutils
      killall
      docker
      fd
      git
      btop
      jq
      neovim
      tokei
      wget
      lazydocker
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

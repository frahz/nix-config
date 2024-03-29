{
  inputs,
  config,
  lib,
  pkgs,
  overlay-unstable,
  overlay-local,
  system,
  ...
}: {
  imports =
    [
      ../users/frahz
      ../modules/nix.nix
    ]
    ++ (
      import ../modules/services
      ++ import ../modules/shell
    );

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      bat
      ripgrep
      binutils
      coreutils
      docker
      fd
      git
      btop
      jq
      neovim
      tokei
      wget
      lazydocker
      unstable.tailscale
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

  /*
  networking.networkmanager.enable = true;
  */

  system.stateVersion = "23.11";
}

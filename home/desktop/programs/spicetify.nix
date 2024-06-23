{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [inputs.spicetify-nix.homeManagerModule];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "custom";
    customColorScheme = {
      accent = "f5c2e7";
      accent-active = "f5c2e7";
      accent-inactive = "1e1e2e";
      banner = "f5c2e7";
      border-active = "f5c2e7";
      border-inactive = "313244";
      header = "585b70";
      highlight = "585b70";
      main = "1e1e2e";
      notification = "89b4fa";
      notification-error = "f38ba8";
      subtext = "a6adc8";
      text = "cdd6f4";
    };
  };
}

{pkgs, ...}: {
  programs.btop = {
    enable = true;
    settings.color_theme = "catppuccin_mocha";
  };

  xdg.configFile = {
    "btop/themes/catppuccin_mocha.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme";
      hash = "sha256-THRpq5vaKCwf9gaso3ycC4TNDLZtBB5Ofh/tOXkfRkQ=";
    };
  };
}

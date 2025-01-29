{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [bemoji];
    sessionVariables = {
      BEMOJI_PICKER_CMD = "${lib.getExe pkgs.fuzzel} --dmenu";
    };
  };
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka:size=12";
        icon-theme = "Papirus";
        anchor = "top";
        y-margin = 360;
        lines = 5;
        width = 48;
        tabs = 4;
        horizontal-pad = 24;
        line-height = 30;
      };
      colors = {
        background = "000000ff";
        text = "e0cda5ff";
        prompt = "f5bde6ff";
        input = "e0cda5ff";
        match = "f5bde6ff";
        selection = "130f12ff";
        selection-match = "f5bde6ff";
        selection-text = "e0cda5ff";
        border = "1b1b1dff";
      };
      border = {
        width = 2;
        radius = 5;
      };
    };
  };
}

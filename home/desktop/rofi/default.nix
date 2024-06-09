{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Iosevka 14";
    extraConfig = {
      drun-display-format = " {name} ";
      show-icons = true;

      display-drun = "";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background = mkLiteral "#1E1E2EFF";
        background-alt = mkLiteral "#313244FF";
        foreground = mkLiteral "#CDD6F4FF";
        selected = mkLiteral "#89B4FAFF";
        active = mkLiteral "#A6E3A1FF";
        urgent = mkLiteral "#F38BA8FF";
      };
      "window" = {
        enabled = mkLiteral "true";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = mkLiteral "false";
        width = mkLiteral "450px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        border-radius = mkLiteral "6px";
        border = mkLiteral "2px";
        border-color = mkLiteral "#313244FF";
        # cursor = "default";
        background-color = mkLiteral "@background";
      };
      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "0px";
        background-color = mkLiteral "transparent";
        orientation = mkLiteral "vertical";
        children = mkLiteral "[inputbar,listbox]";
      };
      "listbox" = {
        spacing = mkLiteral "10px";
        padding = mkLiteral "10px 10px 10px 15px";
        background-color = mkLiteral "transparent";
        orientation = mkLiteral "vertical";
        children = mkLiteral "[message,listview]";
      };
      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "8px";
        padding = mkLiteral "4px 8px";
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@foreground";
        orientation = mkLiteral "horizontal";
        children = mkLiteral "[prompt,entry]";
      };
      "entry" = {
        enabled = true;
        expand = true;
        width = mkLiteral "300px";
        padding = mkLiteral "12px 15px";
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search";
        placeholder-color = mkLiteral "inherit";
      };
      "prompt" = {
        width = mkLiteral "64px";
        font = "Iosevka 13";
        padding = mkLiteral "10px 20px 10px 20px";
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
      };
      "mode-switcher" = {
        enabled = true;
        spacing = mkLiteral "10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
      };
      "button" = {
        width = mkLiteral "48px";
        font = "Iosevka 14";
        padding = mkLiteral "8px 5px 8px 8px";
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
      };
      "button selected" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@foreground";
      };
      "listview" = {
        enabled = true;
        columns = 1;
        lines = 7;
        dynamic = true;
        srollbar = false;
        # layout = mkLiteral "vertical";
        # reverse = false;
        fixed-height = false;
        padding = mkLiteral "4px 0px";
        # fixed-columns = false;
        # spacing = mkLiteral "5px";
        # background-color = mkLiteral "transparent";
        # text-color = mkLiteral "@foreground";
        # cursor = mkLiteral "default";
      };
      "element" = {
        enabled = true;
        spacing = mkLiteral "8px";
        padding = mkLiteral "4px 8px";
        # border-radius = mkLiteral "100%";
        # background-color = mkLiteral "transparent";
        # text-color = mkLiteral "@foreground";
        # cursor = mkLiteral "pointer";
      };
      "element normal.normal" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@foreground";
      };
      "element normal.active" = {
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@active";
      };
      "element selected.normal" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@foreground";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@foreground";
      };
      "element selected.active" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@active";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "0.8em";
        cursor = mkLiteral "inherit";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      "message" = {background-color = mkLiteral "transparent";};
      "textbox" = {
        padding = mkLiteral "12px";
        border-radius = mkLiteral "100%";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      "error-message" = {
        padding = mkLiteral "12px";
        border-radius = mkLiteral "20px";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
      };
    };
  };
}

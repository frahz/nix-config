{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  cfg = config.casa.profiles.graphical;
  gtkTheme = pkgs.colloid-gtk-theme.override {
    colorVariants = singleton "dark";
    themeVariants = singleton "default";
    sizeVariants = singleton "compact";
    tweaks = [
      "rimless"
      "black"
    ];
  };
  iconTheme = pkgs.catppuccin-papirus-folders.override {
    accent = "pink";
    flavor = "mocha";
  };
  gtkSettings = {
    Settings = {
      gtk-application-prefer-dark-theme = true;
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-theme-name = "Colloid-Dark-Compact";
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = builtins.attrValues {
        inherit (pkgs)
          bibata-cursors
          glib
          ;
        inherit (pkgs.kdePackages) qtstyleplugin-kvantum;
        inherit gtkTheme iconTheme;
      };

      environment.sessionVariables = {
        GTK2_RC_FILES = "${config.users.users.frahz.home}/.gtkrc-2.0";
        QT_QPA_PLATFORMTHEME = "kvantum";
        QT_STYLE_OVERRIDE = "kvantum";
        XCURSOR_SIZE = 22;
        XCURSOR_THEME = "Bibata-Modern-Classic";
      };

      files = {
        ".gtkrc-2.0".text = ''
          gtk-theme-name="Colloid-Dark-Compact"
          gtk-icon-theme-name="Papirus-Dark"
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
          gtk-enable-event-sounds=0
          gtk-enable-input-feedback-sounds=0
        '';
        ".icons/Bibata-Modern-Classic".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
        ".icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=Bibata-Modern-Classic
        '';
      };

      xdg.config.files = {
        "gtk-3.0/settings.ini" = {
          generator = (pkgs.formats.ini { }).generate "gtk3-settings.ini";
          value = gtkSettings;
        };
        "gtk-4.0/settings.ini" = {
          generator = (pkgs.formats.ini { }).generate "gtk4-settings.ini";
          value = gtkSettings;
        };
        "gtk-4.0/gtk.css".source = "${gtkTheme}/share/themes/Colloid-Dark-Compact/gtk-4.0/gtk.css";
        "Kvantum/catppuccin-mocha-pink".source =
          "${config.catppuccin.sources.kvantum}/share/Kvantum/catppuccin-mocha-pink";
        "Kvantum/kvantum.kvconfig".text = ''
          [General]
          theme=catppuccin-mocha-pink
        '';
      };

      xdg.data.files = {
        "icons/Bibata-Modern-Classic".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
        "icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=Bibata-Modern-Classic
        '';
      };
    };
  };
}

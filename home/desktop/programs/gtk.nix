{pkgs, ...}: {
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      size = "compact";
      tweaks = ["rimless"];
      icon.enable = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
      gtk-enable-event-sounds=0
      gtk-enable-input-feedback-sounds=0
    '';
  };
}

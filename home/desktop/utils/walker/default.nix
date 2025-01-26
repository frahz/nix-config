{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.walker.homeManagerModules.default];

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      activation_mode.disabled = true; # Key chords
      close_when_open = true;
      disable_click_to_close = false;
      force_keyboard_focus = true;
      hotreload_theme = true;
      ignore_mouse = false;
    };
    theme = {
      style = ''
        #window {
          background: none;
        }
        #list {
          background: none;
        }
      '';
    };
  };
}

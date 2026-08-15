{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  sources = config.catppuccin.sources;
in
{
  hjem.users.frahz = {
    packages = singleton pkgs.tmux;
    environment.sessionVariables = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      TMUX_TMPDIR = "\${XDG_RUNTIME_DIR:-\"/run/user/$(id -u)\"}";
    };
    xdg.config.files."tmux/tmux.conf".text = ''
      set -g default-terminal "xterm-256color"
      set -g base-index 1
      setw -g pane-base-index 1
      set -g mouse on
      set -g history-limit 10000
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_text_color "#{@thm_bg}"
      set -g @catppuccin_window_current_text " #W"
      set -g @catppuccin_window_current_text_color "#{@thm_bg}"
      set -g @catppuccin_status_background none
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right-length 100
      set -g status-right "#{E:@catppuccin_status_directory}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -g @catppuccin_status_left_separator "█"
      set -g @catppuccin_status_right_separator "█"
      set -g @catppuccin_directory_icon "  "
      set -g @catppuccin_directory_text " #{b:pane_current_path}"
      run-shell ${sources.tmux}/share/tmux-plugins/catppuccin/catppuccin.tmux
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g set-clipboard on
      set -g renumber-windows on
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n M-n previous-window
      bind -n M-p next-window
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}

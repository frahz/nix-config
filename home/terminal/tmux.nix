{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    terminal = "xterm-256color";
    baseIndex = 1;
    mouse = true;
    historyLimit = 10000;

    plugins = with pkgs.tmuxPlugins; [
      resurrect
    ];

    catppuccin = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_window_number_position "left"

        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"

        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W"

        set -g @catppuccin_status_modules_right "directory session"
        set -g @catppuccin_status_left_separator "█"
        set -g @catppuccin_status_right_separator "█"
        set -g @catppuccin_directory_text "#{b:pane_current_path}"
      '';
    };

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      # turn on clipboard for osc52
      set -g set-clipboard on

      # renumber windows after one gets deleted
      set -g renumber-windows on

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # switch window keybinds
      bind -n M-n previous-window
      bind -n M-p next-window

      # new panes in current directory
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}

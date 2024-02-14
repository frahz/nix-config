{ pkgs, ... }:

{
    programs.tmux = {
        enable = true;

        terminal = "xterm-256color";
        baseIndex = 1;
        mouse = true;
        historyLimit = 10000;

        plugins = with pkgs.tmuxPlugins; [
            resurrect
            (catppuccin.overrideAttrs ( _: {
                src = pkgs.fetchFromGitHub {
                    owner = "frahz";
                    repo = "catppuccin-tmux";
                    rev = "62a03d68775df1e69f35b9e40e37b2a1c274d859";
                    hash = "sha256-VvVZHAZNGQ4YUYrVHK09wQ9DijhtUwL2jiLuco1MBxE=";
                };
            }))
        ];

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

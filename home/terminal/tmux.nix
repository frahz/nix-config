{ pkgs, ... }:

let
    catppuccin-frahz = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "catppuccin-frahz";
        version = "recent";
        src = pkgs.fetchFromGitHub {
            owner = "frahz";
            repo = "catppuccin-tmux";
            rev = "";
            hash = "";
        };
    };
in {
    programs.tmux = {
        enable = true;

        terminal = "xterm-256color";
        baseIndex = 1;
        mouse = true;
        historyLimit = 10000;

        plugins = with pkgs.tmuxPlugins; [
            resurrect
            catppuccin-frahz
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

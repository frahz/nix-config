{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor.fhsWithPackages (pkgs: [pkgs.zlib pkgs.openssl]);
    extensions = [
      # langs
      "html"
      "toml"
      "git-firefly"
      "svelte"
      "scss"
      "nix"
      "gosum"
      "scls"
      "lua"
      "mermaid"

      # misc
      "env"

      # themes
      "catppuccin"
      "catppuccin-icons"
    ];
    userSettings = {
      autosave = "on_focus_change";
      ui_font_size = 14;
      ui_font_family = "Berkeley Mono";
      buffer_font_size = 14;
      buffer_font_family = "Berkeley Mono";
      relative_line_numbers = true;
      hour_format = "hour24";
      theme = {
        dark = "Catppuccin Mocha";
        light = "Catppuccin Mocha";
      };
      icon_theme = {
        dark = "Catppuccin Mocha";
        light = "Catppuccin Mocha";
      };
      tabs = {
        file_icons = true;
        git_status = true;
      };
      indent_guides = {
        enable = true;
      };
      inlay_hints = {
        enable = true;
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      # assistant = {
      #   default_model = {
      #     provider = "copilot_chat";
      #     model = "gpt-4o";
      #   };
      #   version = "2";
      # };
      diagnostics = {
        inline = {
          enabled = true;
          update_debounce_ms = 150;
          padding = 4;
          max_severity = null;
        };
      };
      languages = {
        Nix = {
          language_servers = ["nil"];
          formatter = {
            external = {
              command = "alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };
      };
    };
  };
}

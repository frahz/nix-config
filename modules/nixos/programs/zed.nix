{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  cfg = config.casa.profiles.graphical;
  extensions = [
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
    "env"
    "catppuccin"
    "catppuccin-icons"
  ];
  package = pkgs.zed-editor.fhsWithPackages (ps: [
    ps.zlib
    ps.openssl
  ]);
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = singleton package;
      xdg.config.files."zed/settings.json" = {
        generator = (pkgs.formats.json { }).generate "zed-settings.json";
        value = {
          auto_install_extensions = lib.genAttrs extensions (_: true);
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
          indent_guides.enable = true;
          inlay_hints.enable = true;
          telemetry = {
            diagnostics = false;
            metrics = false;
          };
          diagnostics.inline = {
            enabled = true;
            update_debounce_ms = 150;
            padding = 4;
            max_severity = null;
          };
          languages.Nix = {
            language_servers = singleton "nil";
            formatter.external.command = "nixfmt";
          };
        };
      };
    };
  };
}

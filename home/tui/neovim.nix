{
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
let
  inherit (lib) optionals concatLists;

  cfg = osConfig.casa;
in
{
  home.packages =
    with pkgs;
    concatLists [
      [ inputs.nvim-flake.packages.${pkgs.stdenv.hostPlatform.system}.default ]

      (optionals cfg.profiles.development.enable [
        # LSP stuff
        bash-language-server
        gopls
        htmx-lsp
        lua-language-server
        libclang
        marksman
        nil
        pyright
        rust-analyzer
        svelte-language-server
        tailwindcss-language-server
        tinymist
        typescript-language-server
        vscode-langservers-extracted

        # Formatters
        typstyle
        nixfmt

        websocat
      ])
    ];
}

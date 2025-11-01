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
        libclang
        nil
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        pyright
        rust-analyzer
        lua-language-server
        gopls
        vscode-langservers-extracted
        htmx-lsp
        tailwindcss-language-server
        svelte-language-server
        tinymist
        marksman
        # Formatters
        typstyle
      ])
    ];
}

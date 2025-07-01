{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.nvim-flake.packages.${pkgs.system}.default

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
    # tailwindcss-language-server
    svelte-language-server
    tinymist
    marksman

    # Formatters
    typstyle
  ];
}

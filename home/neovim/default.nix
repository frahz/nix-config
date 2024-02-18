{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    withNodeJs = false;
    withRuby = false;

    extraLuaConfig = builtins.readFile "${./init.lua}";
    plugins = with pkgs.vimPlugins; [
      # Autocomplete
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-omni
      cmp_luasnip

      # LSP Config
      nvim-lspconfig
      {
        plugin = fidget-nvim;
        type = "lua";
        config = ''
          require("fidget").setup({})
        '';
      }

      # Treesitter / Syntax Highlighting
      nvim-treesitter.withAllGrammars

      # Telescope
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim

      # Snippets
      luasnip
      friendly-snippets

      # Symbol Viewer
      aerial-nvim

      # Better comment keybinds
      vim-commentary

      # Autopairs (works with cmp engine)
      nvim-autopairs

      # Indent guides
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require("indent_blankline").setup({
              char = "▏",
              space_char_blankline = " ",
              filetype_exclude = { "alpha", "help", "mason", "terminal", "packer", "lspinfo", "TelescopePrompt", "TelescopeResults" },
              buftype_exclude = { "terminal" , "nofile" },
              show_first_indent_level = false,
          })
        '';
      }

      # Detect indentation style
      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''
          require("guess-indent").setup({})
        '';
      }

      # Statusline
      nvim-web-devicons
      lualine-nvim

      # Git support
      gitsigns-nvim

      # Nicer looking netrw
      # TODO: add prichrd/netrw.nvim

      # Greeter
      alpha-nvim

      # Copy in ssh/tmux
      {
        plugin = nvim-osc52;
        type = "lua";
        config = ''
          require("osc52").setup({silent = true})
        '';
      }

      # Theme
      catppuccin-nvim

      # Improve startuptime
      # impatient-nvim
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
      gcc
      git

      # LSP stuff
      libclang
      nil
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.pyright
      rust-analyzer
      sumneko-lua-language-server
    ];
  };

  xdg.configFile."nvim/lua/config" = {
    recursive = true;
    source = ./config;
  };
}

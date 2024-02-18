{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    withNodeJs = false;
    withRuby = false;

    extraLuaConfig = builtins.readFile "${./init.lua}";
    plugins = with pkgs.vimPlugins; [
      # Autocomplete
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          require("config.completion")
        '';
      }
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-omni
      cmp_luasnip

      # LSP Config
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require("config.lsp")
        '';
      }
      {
        plugin = fidget-nvim;
        type = "lua";
        config = ''
          require("fidget").setup({})
        '';
      }

      # Treesitter / Syntax Highlighting
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require("config.treesitter")
        '';
      }

      # Telescope
      plenary-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("config.telescope")
        '';
      }
      telescope-fzf-native-nvim

      # Snippets
      luasnip
      friendly-snippets

      # Symbol Viewer
      {
        plugin = aerial-nvim;
        type = "lua";
        config = ''
          require("config.tags")
        '';
      }

      # Better comment keybinds
      vim-commentary

      # Autopairs (works with cmp engine)
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("config.autopairs")
        '';
      }

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
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("config.statusline")
        '';
      }

      # Git support
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require("config.gitsigns")
        '';
      }

      # Nicer looking netrw
      # TODO: add prichrd/netrw.nvim

      # Greeter
      {
        plugin = alpha-nvim;
        type = "lua";
        config = ''
          require("config.alpha")
        '';
      }

      # Copy in ssh/tmux
      {
        plugin = nvim-osc52;
        type = "lua";
        config = ''
          require("osc52").setup({silent = true})
        '';
      }

      # Theme
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''
          require("config.theme")
        '';
      }

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

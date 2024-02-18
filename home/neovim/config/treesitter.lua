local configs = require("nvim-treesitter.configs")

configs.setup({
    ensure_installed = {
        "python",
        "lua",
        "rust",
        "cpp",
        "c",
        "bash",
        "java",
        "css",
        "html",
        "typescript",
        "javascript",
        "toml",
        "yaml",
        "nix"
    },
    highlight = {
        enable = true,
        -- disable = { "c" },
    }
})

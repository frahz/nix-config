local catppuccin = require("catppuccin");

catppuccin.setup({
    flavour = "mocha",
    styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        treesitter = true,
        cmp = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = {},
                hints = {},
                warnings = {},
                information = {},
            },
        },
        mason = true,
    },
    custom_highlights = function()
        return {
            ["@parameter"] = { style = {} },
            ["@namespace"] = { style = {} },
            ["@text.emphasis"] = { style = {} },
            ["@text.literal"] = { style = {} },
            ["@text.uri"] = { style =  { "underline" } },
            ["@tag.attribute"] = { style = {} },
        }
    end
})

vim.api.nvim_command("colorscheme catppuccin")

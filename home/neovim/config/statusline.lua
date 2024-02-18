local lualine = require("lualine")

local section_separators = { left = "", right = ""}
if vim.fn.has("mac") == 1 then
    section_separators = { left = "", right = ""}
end

local function shiftwidth()
    return " "..vim.api.nvim_get_option_value("shiftwidth", {})
end

lualine.setup({
    options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = { left = "", right = ""},
        section_separators = section_separators,
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff", "diagnostics"},
        lualine_c = {"progress", "location"},
        lualine_x = {shiftwidth},
        lualine_y = {"filetype"},
        lualine_z = {"filename"}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
})

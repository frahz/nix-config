-- [[ options.lua ]]
local opt = vim.opt

-- [[ context ]]
opt.nu = true
opt.relativenumber = true
opt.scrolloff = 8

-- [[ whitespace ]]
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- [[ search ]]
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- [[ misc ]]
opt.swapfile = false

-- [[ indent ]]
opt.list = true
opt.listchars = {
    lead = "⋅",
    tab = "│ ",
    trail = "•",
}

-- [[ ssh clipbard ]] (will move to its own file later)
local function copy(lines, _)
    require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
    return {vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("")}
end

vim.g.clipboard = {
    name = "osc52",
    copy = {["+"] = copy, ["*"] = copy},
    paste = {["+"] = paste, ["*"] = paste},
}

-- [[ netrw ]]
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = ""
vim.g.netrw_list_hide = vim.g.netrw_list_hide .. "^\\./" -- hide . directory
vim.g.netrw_list_hide = vim.g.netrw_list_hide .. ","

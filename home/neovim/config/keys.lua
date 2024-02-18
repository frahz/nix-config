-- function wrapper for mapping custom keybinds
local map = function(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- leader keymap
vim.g.mapleader = " " -- space

-- center line after jump
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "n", "nzz")

-- keybinds for moving a line up or down
map("n", "<S-Up>", "<cmd>m-2<CR>")
map("n", "<S-Down>", "<cmd>m+<CR>")
map("i", "<S-Up>", "<Esc><cmd>m-2<CR>")
map("i", "<S-Down>", "<Esc><cmd>m+<CR>")
map("v", "<S-Up>", ":m '<-2<CR>gv=gv")
map("v", "<S-Down>", ":m '>+1<CR>gv=gv")

-- paste over something but still keep the same thing in the paste buffer
map("x", "<Leader>p", "\"_dP")

-- disable hlsearch
map("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>")

-- allows paste outside vim
map("n", "<Leader>y", "\"+y")
map("v", "<Leader>y", "\"+y")
map("n", "<Leader>Y", "\"+Y")

-- Telescope
map("n", "<Leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<Leader>fg", "<cmd>Telescope git_files<CR>")
map("n", "<Leader>fw", "<cmd>Telescope live_grep<CR>")
map("n", "<Leader>fh", "<cmd>Telescope buffers<CR>")
map("n", "<Leader>fs", "<cmd>Telescope grep_string<CR>")
map("n", "<Leader>fo", "<cmd>Telescope oldfiles<CR>")
map("n", "<Leader>fc", "<cmd>Telescope git_commits<CR>")
map("n", "<Leader>fd", "<cmd>Telescope diagnostics<CR>")
map("n", "<Leader>k", "<cmd>Telescope keymaps<CR>")


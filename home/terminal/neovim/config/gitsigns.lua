require("gitsigns").setup({
    signs = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "_" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
    },
    on_attach = function ()
        local gs = package.loaded.gitsigns

        local map = function (mode, l, r, opts)
            opts = opts or {}
            vim.keymap.set(mode, l, r, opts)
        end

        map("n", "<leader>tb", gs.toggle_current_line_blame)
        map("n", "<leader>hd", gs.diffthis)
    end
})

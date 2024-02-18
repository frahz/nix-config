local telescope = require("telescope")

local actions = require("telescope.actions")

telescope.setup({
    defaults = {
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.65,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",

        }
    }
})
telescope.load_extension("fzf")

local nvim_lsp = require("lspconfig")
require("config.lsp_handlers").setup()

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


local on_attach = function(client)
    -- Don't know what this does ??
    -- require("cmp").on_attach(client)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = self,
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            files = {
                excludeDirs = { ".direnv" },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

nvim_lsp.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {},
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- TODO: fix "error" where diagnostics virtual text doesn't show up unless I reload nvim
nvim_lsp.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--clang-tidy",
        "--suggest-missing-includes",
        "--all-scopes-completion",
        "--pretty",
    },
    filetypes = { "c", "cpp", "cc" },
})

nvim_lsp.nil_ls.setup({
    on_attach = on_attach,
    auto_start = true,
    capabilities = capabilities,
    settings = {
        ['nil'] = {
            formatting = {
                command = { "alejandra" },
            },
            nix = {
                maxMemoryMB = 8196,
                flake = {
                    autoArchive = false,
                    autoEvalInputs = true,
                },
            }
        },
    },
})

nvim_lsp.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
nvim_lsp.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "django-html", "htmldjango", "html", "templ" }
})

-- nvim_lsp.htmx.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })

nvim_lsp.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.marksman.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.svelte.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.tinymist.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        formatterMode = "typstyle",
    },
})

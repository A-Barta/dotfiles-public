return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "ruff",
                "clangd",
            },
            handlers = {
                function(server_name) -- default handler (optional)

                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
		["ruff"] = function()
		    local lspconfig = require("lspconfig")
		    lspconfig.ruff.setup {
		        capabilities = capabilities,
			init_options = {
                            settings = {
                                args = {}, -- You can add "--config", "path/to/ruff.toml" if needed
                            },
                        },
		    }
		end,
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                        cmd = {
                            -- "/home/antonio/.espressif/tools/esp-clang/esp-18.1.2_20240912/esp-clang/bin/clangd",
                            "/usr/bin/clangd",
                            "--all-scopes-completion",
                            "--background-index",
                            "--clang-tidy",
                            "--compile_args_from=filesystem", -- lsp-> does not come from compie_commands.json
                            "--completion-parse=always",
                            "--completion-style=bundled",
                            "--debug-origin",
                            "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
                            "--fallback-style=LLVM",
                            "--function-arg-placeholders",
                            "--header-insertion=iwyu",
                            "--pch-storage=memory", -- could also be disk
                            "-j=4", -- number of workers
                            "--log=error",
                        },
                    }
                end
            }
        })

        -- Buffer-local LSP keymaps, set only once a server attaches to a buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("bartarian_lsp_attach", { clear = true }),
            callback = function(event)
                local function map(keys, fn, desc)
                    vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Navigation (Telescope-backed where it gives a picker)
                map("gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
                map("gr", "<cmd>Telescope lsp_references<cr>", "Go to references")
                map("gi", "<cmd>Telescope lsp_implementations<cr>", "Go to implementation")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")

                -- Information
                map("K", vim.lsp.buf.hover, "Hover documentation")

                -- Actions
                map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

                -- Diagnostics
                map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
                map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
                map("<leader>vd", vim.diagnostic.open_float, "Show diagnostic float")
            end,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}

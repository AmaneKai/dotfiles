return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()
      local lspconfig = require("lspconfig")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = has_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd", "lua_ls", "tailwindcss", "html",
          "vtsls", "gopls", "htmx", "rust_analyzer", "svelte", "eslint",
        },
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({ capabilities = capabilities })
          end,

          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = { Lua = { diagnostics = { globals = { "vim" } } } },
            })
          end,

          ["vtsls"] = function()
            lspconfig.vtsls.setup({
              capabilities = capabilities,
              settings = {
                typescript = {
                  updateImportsOnFileMove = { enabled = "always" },
                  suggest = {
                    completeFunctionCalls = false,
                  },
                  preferences = {
                    importModuleSpecifierPreference = "non-relative",
                    includeCompletionsForModuleExports = true,
                  },
                  inlayHints = {
                    parameterNames = { enabled = "none" },
                    parameterTypes = { enabled = false },
                    variableTypes = { enabled = false },
                    propertyDeclarationTypes = { enabled = false },
                    functionLikeReturnTypes = { enabled = false },
                    enumMemberValues = { enabled = false },
                  },
                },
                javascript = {
                  updateImportsOnFileMove = { enabled = "always" },
                  suggest = {
                    completeFunctionCalls = false,
                  },
                  preferences = {
                    importModuleSpecifierPreference = "non-relative",
                    includeCompletionsForModuleExports = true,
                  },
                  inlayHints = {
                    parameterNames = { enabled = "none" },
                    parameterTypes = { enabled = false },
                    variableTypes = { enabled = false },
                    propertyDeclarationTypes = { enabled = false },
                    functionLikeReturnTypes = { enabled = false },
                    enumMemberValues = { enabled = false },
                  },
                },
                vtsls = {
                  autoUseWorkspaceTsdk = true,
                  experimental = {
                    completion = {
                      enableServerSideFuzzyMatch = true,
                    },
                  },
                },
              },
            })
          end,

          ["tailwindcss"] = function()
            lspconfig.tailwindcss.setup({
              capabilities = capabilities,
              settings = {
                tailwindCSS = {
                  includeLanguages = { rust = "html" },
                  experimental = { classRegex = { 'class="([^"]*)"', 'class=([^,)]*)' } },
                },
              },
            })
          end,

          ["html"] = function()
            lspconfig.html.setup({
              capabilities = capabilities,
              init_options = {
                provideFormatter = true,
                embeddedLanguages = { css = true, javascript = true },
                configurationSection = { "html", "css", "javascript" },
              },
              settings = { html = { format = { templated = true }, suggest = { html5 = true } } },
            })
          end,

          ["svelte"] = function()
            lspconfig.svelte.setup({
              capabilities = capabilities,
              on_attach = function(client, _)
                vim.api.nvim_create_autocmd("BufWritePost", {
                  pattern = { "*.ts", "*.js" },
                  callback = function(ctx)
                    client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                  end,
                })
              end,
              settings = {
                typescript = {
                  inlayHints = {
                    parameterNames = { enabled = "literals" },
                    parameterTypes = { enabled = true },
                    variableTypes = { enabled = true },
                    propertyDeclarationTypes = { enabled = true },
                    functionLikeReturnTypes = { enabled = true },
                    enumMemberValues = { enabled = true },
                  },
                },
              },
            })
          end,

          ["gopls"] = function()
            lspconfig.gopls.setup({
              capabilities = capabilities,
              settings = {
                gopls = {
                  completeUnimported = true,
                  usePlaceholders = true,
                  analyses = { unusedparams = true },
                },
              },
            })
          end,

          ["rust_analyzer"] = function()
            lspconfig.rust_analyzer.setup({
              capabilities = capabilities,
              settings = {
                ["rust-analyzer"] = {
                  check = { command = "clippy" },
                  checkOnSave = true,
                  procMacro = { enable = true },
                  cargo = { features = "all" },
                },
              },
            })
          end,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set("n", "gd",          vim.lsp.buf.definition,       opts)
          vim.keymap.set("n", "K",           vim.lsp.buf.hover,            opts)
          vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
          vim.keymap.set("n", "<leader>vd",  vim.diagnostic.open_float,    opts)
          vim.keymap.set("n", "[d",          vim.diagnostic.goto_prev,     opts)
          vim.keymap.set("n", "]d",          vim.diagnostic.goto_next,     opts)
          vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action,      opts)
          vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references,       opts)
          vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename,           opts)
          vim.keymap.set("i", "<C-h>",       vim.lsp.buf.signature_help,   opts)

          vim.keymap.set("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, { desc = "Toggle Inlay Hints", buffer = event.buf })

          vim.keymap.set("n", "<leader>td", function()
            local config = vim.diagnostic.config()
            vim.diagnostic.config({
              virtual_text = not config.virtual_text,
            })
          end, { desc = "Toggle Diagnostics", buffer = event.buf })
        end,
      })
    end,
  },
}

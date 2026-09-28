local ts_js = {
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
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = has_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = ts_js,
          javascript = ts_js,
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

      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = {
            includeLanguages = { rust = "html" },
            experimental = { classRegex = { 'class="([^"]*)"', 'class=([^,)]*)' } },
          },
        },
      })

      vim.lsp.config("html", {
        init_options = {
          provideFormatter = true,
          embeddedLanguages = { css = true, javascript = true },
          configurationSection = { "html", "css", "javascript" },
        },
        settings = { html = { format = { templated = true }, suggest = { html5 = true } } },
      })

      vim.lsp.config("svelte", {
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

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            checkOnSave = true,
            procMacro = { enable = true },
            cargo = { features = "all" },
          },
        },
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "tailwindcss", "html",
          "vtsls", "rust_analyzer", "svelte", "eslint",
          "pyright",
        },
      })

      if vim.fn.executable("gopls") == 1 then
        vim.lsp.enable("gopls")
      end

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

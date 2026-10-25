local servers = {
  "clangd",
  "gopls",
  "pyright",
  "lua_ls",
  "ts_ls",
  "tinymist",
  "ltex_plus",
}

return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = servers,
      automatic_enable = false,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      local dict_path = vim.fn.stdpath("config") .. "/spell/ltex-dictionary.txt"
      vim.lsp.config("ltex_plus", {
        filetypes = { "markdown", "text", "tex", "typst" },
        settings = {
          ltex = {
            language = "en-US",
            dictionary = {
              ["en-US"] = vim.fn.filereadable(dict_path) == 1 and vim.fn.readfile(dict_path) or {},
            },
            additionalRules = { enablePickyRules = true },
          },
        },
      })
      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function map(lhs, fn, desc)
            vim.keymap.set("n", lhs, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("<leader>gd", vim.lsp.buf.definition,     "Go to definition")
          map("gd",         vim.lsp.buf.definition,     "Go to definition")
          map("<leader>gD", vim.lsp.buf.declaration,    "Go to declaration")
          map("<leader>gi", vim.lsp.buf.implementation, "Go to implementation")
          map("<leader>gR", vim.lsp.buf.references,     "References")
          map("<leader>rn", vim.lsp.buf.rename,         "Rename")
          map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
          map("<leader>gl", vim.diagnostic.open_float,  "Line diagnostics")
        end,
      })
    end,
  },
}

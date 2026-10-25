return {
  {
    "spell-config",
    dir = vim.fn.stdpath("config"),
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = { "typst", "markdown", "text", "tex" },
        callback = function()
          -- ltex_plus (LSP) does the checking; built-in spell stays off to avoid double underlines
          vim.wo.spell = false

          vim.keymap.set("n", "<leader>ss", function()
            local on = not vim.diagnostic.is_enabled({ bufnr = 0 })
            vim.diagnostic.enable(on, { bufnr = 0 })
            print("Grammar/spell check: " .. (on and "ON" or "OFF"))
          end, { buffer = true, desc = "Toggle grammar/spell check" })

          vim.keymap.set("n", "<leader>sc", vim.lsp.buf.code_action, { buffer = true, desc = "Fix suggestion" })
          vim.keymap.set("n", "]s", vim.diagnostic.goto_next, { buffer = true })
          vim.keymap.set("n", "[s", vim.diagnostic.goto_prev, { buffer = true })
        end,
      })

      vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#f38ba8" })
      vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#fab387" })
    end,
  },
}

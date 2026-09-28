return {
  {
    "spell-config",
    dir = vim.fn.stdpath("config"),
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = { "typst", "markdown", "text", "tex" },
        callback = function()
          vim.wo.spell = true
          vim.opt_local.spelllang = "en_us"

          vim.keymap.set("n", "<leader>ss", function()
            vim.wo.spell = not vim.wo.spell
            print("Spell check: " .. (vim.wo.spell and "ON" or "OFF"))
          end, { buffer = true, desc = "Toggle spell check" })

          vim.keymap.set("n", "<leader>sa", "zg", { buffer = true, silent = true })
          vim.keymap.set("n", "<leader>sc", "z=", { buffer = true, silent = true })
        end,
      })

      vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#f38ba8" })
      vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#fab387" })
    end,
  },
}

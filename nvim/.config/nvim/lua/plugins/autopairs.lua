return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = {
          "lua", "c", "cpp", "rust", "python",
          "java", "javascript", "typescript",
        },
        check_ts = true,
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close          = true,
          enable_rename         = true,
          enable_close_on_slash = false,
        },
        filetypes = { "html", "xml", "javascriptreact", "typescriptreact" },
      })
    end,
  },
}

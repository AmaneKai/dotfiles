return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = has_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

      require("roslyn").setup({
        config = { capabilities = capabilities },
      })
    end,
  },

  {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "fsharp" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("easy-dotnet").setup()

      local dotnet = require("easy-dotnet")
      vim.keymap.set("n", "<leader>dr", dotnet.run,     { desc = ".NET Run" })
      vim.keymap.set("n", "<leader>dt", dotnet.test,    { desc = ".NET Test" })
      vim.keymap.set("n", "<leader>ds", dotnet.secrets, { desc = ".NET Secrets" })
    end,
  },
}

return {
  url = "https://forge.barrettruth.com/barrettruth/live-server.nvim",
  build = "npm install -g live-server",
  config = function()
    vim.g.live_server = {
      port          = 6767,
      no_css_inject = true,
      browser       = "brave browser",
    }

    vim.keymap.set("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
    vim.keymap.set("n", "<leader>lc", ":LiveServerStop<CR>",  { desc = "Stop Live Server" })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
      pattern  = { "*.html", "*.css", "*.js" },
      callback = function() vim.cmd("silent! write") end,
    })
  end,
}

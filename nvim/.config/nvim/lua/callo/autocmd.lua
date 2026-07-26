local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add({
  extension = { ipynb = "ipynb" },
})

local webdev_group = augroup("WebDevIndent", { clear = true })

autocmd("FileType", {
  group = webdev_group,
  pattern = {
    "javascript", "typescript", "javascriptreact", "typescriptreact",
    "html", "css", "json", "svelte", "lua", "yaml", "markdown"
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

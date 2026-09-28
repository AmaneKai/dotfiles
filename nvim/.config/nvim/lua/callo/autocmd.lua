local TWO_SPACE_FILETYPES = {
  "javascript", "typescript", "javascriptreact", "typescriptreact",
  "html", "css", "scss", "json", "jsonc", "svelte", "vue",
  "cpp",
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TwoSpaceIndent", { clear = true }),
  pattern = TWO_SPACE_FILETYPES,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

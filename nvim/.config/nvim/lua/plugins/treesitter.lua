return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "vimdoc", "javascript", "typescript", "lua", "rust",
        "jsdoc", "bash", "html", "css", "tsx", "json", "go",
        "markdown", "markdown_inline", "kotlin", "svelte", "python"
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
      end,
    })

  end,
}

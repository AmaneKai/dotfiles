local PARSERS = {
  "vimdoc", "lua", "bash", "markdown", "markdown_inline", "json",
  "javascript", "typescript", "tsx", "jsdoc", "html", "css", "svelte",
  "python", "go", "rust", "c", "cpp", "c_sharp", "kotlin",
}

local function highlight(buffer)
  pcall(vim.treesitter.start, buffer)
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(PARSERS)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
      callback = function(event) highlight(event.buf) end,
    })

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buffer) then highlight(buffer) end
    end
  end,
}

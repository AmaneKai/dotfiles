return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    build = "cd app && npx --yes yarn install",
    keys = {
      { "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown: Toggle preview" },
    },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme      = "dark"
      vim.g.mkdp_port       = "8081"
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
      }
    end,
  },
}

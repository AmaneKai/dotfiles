return {
  "brianhuster/live-preview.nvim",
  cmd = "LivePreview",
  ft = { "markdown", "html", "css", "javascript", "asciidoc", "svg" },
  keys = {
    { "<leader>ls", "<cmd>LivePreview start<CR>", desc = "Live Preview: Start" },
    { "<leader>lc", "<cmd>LivePreview close<CR>", desc = "Live Preview: Close" },
  },
  config = function()
    require("callo.utils").autosave("LivePreviewAutoSave", { "*.html", "*.css", "*.js" })
  end,
}

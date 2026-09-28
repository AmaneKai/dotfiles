local use_local_dev = false

local spec = use_local_dev
    and { dir = vim.fn.expand("~/Github/md-peek.nvim"), name = "md-peek" }
  or { "AmaneKai/md-peek.nvim" }

spec.build = "cd server && npm install"
spec.ft = { "markdown", "mdx" }
spec.cmd = { "MdPeekOpen", "MdPeekClose", "MdPeekToggle", "MdPeekRefresh", "MdPeekOutline" }
spec.config = function()
  require("md-peek").setup({
    window = { width = 1100, height = 1000 },
    position = { x = 40, y = 40 },
    nvim = {
      status_overlay = false,
    },
    preview = {
      theme = "rose-pine",
      toc_open = false,
      font = {
        mono = "JetBrains Mono, monospace",
      },
    },
    keymaps = {
      open = "<leader>mo",
      close = "<leader>mc",
      toggle = "<leader>mp",
      refresh = "<leader>mr",
      outline = "<leader>mm",
    },
  })
end

return spec

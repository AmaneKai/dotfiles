local use_local_dev = false

local spec = use_local_dev
    and { dir = vim.fn.expand("~/Github/ipynb-peek.nvim"), name = "ipynb-peek" }
  or { "AmaneKai/ipynb-peek.nvim" }

spec.build = "cd server && bun install"
spec.event = { "BufEnter *.ipynb", "BufWinEnter *.ipynb" }
spec.cmd =
  { "IpynbPeekOpen", "IpynbPeekClose", "IpynbPeekRunCell", "IpynbPeekRunAll", "IpynbPeekRestartKernel" }
spec.config = function()
  require("ipynb-peek").setup({
    debounce_ms = 60,
    window = { width = 900, height = 1000 },
    position = { x = 40, y = 40 },
    keymaps = {
      open = "<leader>jo",
      close = "<leader>jc",
      run_cell = "<leader>jr",
      run_all = "<leader>jR",
      restart_kernel = "<leader>jK",
    },
  })
end

return spec

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_ruby_provider    = 0

vim.g.go_recommended_style   = 0
vim.g.yaml_recommended_style = 0

vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.smartindent = true
vim.opt.wrap        = false

vim.opt.guicursor     = ""
vim.opt.nu            = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline    = true
vim.opt.scrolloff     = 8
vim.opt.signcolumn    = "yes"
vim.opt.colorcolumn   = "100"
vim.opt.isfname:append("@-@")

vim.opt.hlsearch  = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

vim.opt.swapfile = false
vim.opt.backup   = false
vim.opt.undofile = true
vim.opt.undodir  = vim.env.HOME .. "/.vim/undodir"

vim.opt.updatetime = 50
vim.opt.shell      = "/bin/bash"
vim.opt.clipboard  = "unnamedplus"
vim.opt.backspace  = "indent,eol,start"
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",[vim.diagnostic.severity.HINT]  = "󰠠 ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  update_in_insert = false,
  underline        = true,
  severity_sort    = true,
  float            = { border = "rounded", source = "always", header = "", prefix = "" },
})


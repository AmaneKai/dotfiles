local utils = require("callo.utils")

-- Navigation
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines while keeping cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centered while scrolling and searching
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n",     "nzzzv")
vim.keymap.set("n", "N",     "Nzzzv")

-- Clipboard
vim.keymap.set("x", "<leader>p",           [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y",  [["+y]])
vim.keymap.set("n", "<leader>Y",           [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d",  [["_d]])

-- LSP utilities
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Misc
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q",     "<nop>")
vim.keymap.set("n", "<leader>s",  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x",  "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>nh", ":nohl<CR>",             { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>+",  "<C-a>",                 { desc = "Increment number" })
vim.keymap.set("n", "<leader>-",  "<C-x>",                 { desc = "Decrement number" })

-- Quickfix / location list
vim.keymap.set("n", "<C-k>",      "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>",      "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k",  "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j",  "<cmd>lprev<CR>zz")

-- Go-style error handling snippet
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- Source config
vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)

-- Explorer & Files
vim.keymap.set("n", "<leader>pr", function() vim.cmd("Explore " .. vim.fn.getcwd()) end, { desc = "Project root explorer" })
vim.keymap.set("n", "<leader>nf", utils.new_relative_file, { desc = "New file in current dir" })
vim.keymap.set("n", "<leader>nF", utils.new_root_file,     { desc = "New file from project root" })

-- Gradle
vim.keymap.set("n", "<leader>gr", function() utils.gradle_cmd("run") end,   { desc = "Gradle run" })
vim.keymap.set("n", "<leader>gb", function() utils.gradle_cmd("build") end, { desc = "Gradle build" })
vim.keymap.set("n", "<leader>gt", function() utils.gradle_cmd("test") end,  { desc = "Gradle test" })

-- Terminal
vim.keymap.set("n", "<leader>tt", "<cmd>below terminal<CR>i", { desc = "Terminal at project root" })

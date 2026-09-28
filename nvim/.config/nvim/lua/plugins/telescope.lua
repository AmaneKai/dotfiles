return {
  "nvim-telescope/telescope.nvim",
  branch       = "master",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local actions   = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        preview  = { treesitter = false },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>pf",  builtin.find_files, { desc = "Telescope: Find files" })
    vim.keymap.set("n", "<C-p>",       builtin.git_files,  { desc = "Telescope: Git files" })
    vim.keymap.set("n", "<leader>ps",  builtin.live_grep,  { desc = "Telescope: Live grep" })
    vim.keymap.set("n", "<leader>pb",  builtin.buffers,    { desc = "Telescope: Buffers" })
    vim.keymap.set("n", "<leader>vh",  builtin.help_tags,  { desc = "Telescope: Help tags" })

    vim.keymap.set("n", "<leader>pws", function()
      builtin.grep_string({ search = vim.fn.expand("<cword>") })
    end, { desc = "Telescope: Grep word under cursor" })
  end,
}

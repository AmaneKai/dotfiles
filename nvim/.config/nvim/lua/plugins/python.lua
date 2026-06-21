return {
  -- ipython REPL managed inside a Neovim split (no tmux needed)
  {
    "Vigemus/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = { command = { "ipython" } },
          },
          repl_open_cmd = require("iron.view").split.vertical.botright(0.4),
        },
        keymaps = {
          send_line    = "<leader>jj",
          visual_send  = "<leader>jr",
          send_file    = "<leader>jf",
          interrupt    = "<leader>j<space>",
          exit         = "<leader>jq",
          clear        = "<leader>jl",
        },
        ignore_blank_lines = true,
      })

      -- send the current # %% cell
      vim.keymap.set("n", "<leader>jc", function()
        local core = require("iron.core")
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local cursor = vim.api.nvim_win_get_cursor(0)[1]

        local cell_start = 1
        for i = cursor, 1, -1 do
          if lines[i]:match("^# %%%%") then
            cell_start = i + 1
            break
          end
        end

        local cell_end = #lines
        for i = cursor + 1, #lines do
          if lines[i]:match("^# %%%%") then
            cell_end = i - 1
            break
          end
        end

        local chunk = vim.list_slice(lines, cell_start, cell_end)
        while #chunk > 0 and chunk[#chunk]:match("^%s*$") do
          table.remove(chunk)
        end
        core.send(nil, chunk)
      end, { desc = "Send # %% cell to ipython" })

      -- send all # %% cells top to bottom
      vim.keymap.set("n", "<leader>ja", function()
        local core = require("iron.core")
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        local boundaries = {}
        for i, line in ipairs(lines) do
          if line:match("^# %%%%") then
            table.insert(boundaries, i)
          end
        end
        table.insert(boundaries, #lines + 1)

        for i = 1, #boundaries - 1 do
          local cell_start = boundaries[i] + 1
          local cell_end = boundaries[i + 1] - 1
          local chunk = vim.list_slice(lines, cell_start, cell_end)
          while #chunk > 0 and chunk[#chunk]:match("^%s*$") do
            table.remove(chunk)
          end
          if #chunk > 0 then
            core.send(nil, chunk)
          end
        end
      end, { desc = "Send all # %% cells to ipython" })

      -- toggle the REPL split open/closed
      vim.keymap.set("n", "<leader>jt", function()
        local view = require("iron.view")
        local core = require("iron.core")
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "iron" then
            vim.api.nvim_win_close(win, false)
            return
          end
        end
        core.repl_here("python")
      end, { desc = "Toggle ipython REPL" })

      vim.keymap.set("n", "<leader>jo", "<cmd>IronRepl<cr>", { desc = "Open ipython REPL" })
      vim.keymap.set("n", "<leader>jh", "<cmd>IronHide<cr>", { desc = "Hide ipython REPL" })
      vim.keymap.set("n", "<leader>jR", "<cmd>IronRestart<cr>", { desc = "Restart ipython REPL" })
    end,
  },

  -- Transparent .ipynb <-> .py(percent) editing; gitignore .ipynb, commit .py
  {
    "goerz/jupytext.vim",
    init = function()
      vim.g.jupytext_fmt = "py:percent"
    end,
  },
}

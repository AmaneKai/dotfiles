local CELL_MARKER = "^# %%%%"

local function is_cell_marker(line)
  return line:match(CELL_MARKER) ~= nil
end

local function buffer_lines()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function cell_body(lines, first, last)
  local body = vim.list_slice(lines, first, last)
  while #body > 0 and body[#body]:match("^%s*$") do
    table.remove(body)
  end
  return body
end

local function send_to_repl(body)
  if #body > 0 then
    require("iron.core").send(nil, body)
  end
end

local function send_cell_under_cursor()
  local lines = buffer_lines()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  local first = 1
  for row = cursor_row, 1, -1 do
    if is_cell_marker(lines[row]) then
      first = row + 1
      break
    end
  end

  local last = #lines
  for row = cursor_row + 1, #lines do
    if is_cell_marker(lines[row]) then
      last = row - 1
      break
    end
  end

  send_to_repl(cell_body(lines, first, last))
end

local function send_all_cells()
  local lines = buffer_lines()
  local markers = {}
  for row, line in ipairs(lines) do
    if is_cell_marker(line) then
      table.insert(markers, row)
    end
  end
  table.insert(markers, #lines + 1)

  for index = 1, #markers - 1 do
    send_to_repl(cell_body(lines, markers[index] + 1, markers[index + 1] - 1))
  end
end

local function toggle_repl()
  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(window)].filetype == "iron" then
      vim.api.nvim_win_close(window, false)
      return
    end
  end
  require("iron.core").repl_here("python")
end

return {
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

      vim.keymap.set("n", "<leader>jc", send_cell_under_cursor, { desc = "Send # %% cell to ipython" })
      vim.keymap.set("n", "<leader>ja", send_all_cells, { desc = "Send all # %% cells to ipython" })
      vim.keymap.set("n", "<leader>jt", toggle_repl, { desc = "Toggle ipython REPL" })
      vim.keymap.set("n", "<leader>jo", "<cmd>IronRepl<cr>", { desc = "Open ipython REPL" })
      vim.keymap.set("n", "<leader>jh", "<cmd>IronHide<cr>", { desc = "Hide ipython REPL" })
      vim.keymap.set("n", "<leader>jR", "<cmd>IronRestart<cr>", { desc = "Restart ipython REPL" })
    end,
  },

  {
    "goerz/jupytext.vim",
    init = function()
      vim.g.jupytext_fmt = "py:percent"
    end,
  },
}

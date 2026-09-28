local M = {}

local function edit_new_file(prompt, base_dir)
  local name = vim.fn.input(prompt)
  if name == "" then return end
  vim.cmd.edit(vim.fn.fnameescape(base_dir .. "/" .. name))
end

function M.new_relative_file()
  edit_new_file("New file (relative to current): ", vim.fn.expand("%:p:h"))
end

function M.new_root_file()
  edit_new_file("New file (from root): ", vim.fn.getcwd())
end

function M.gradle_cmd(task)
  vim.cmd("below terminal cd " .. vim.fn.shellescape(vim.fn.getcwd()) .. " && ./gradlew " .. task)
end

function M.autosave(group_name, pattern, events)
  vim.api.nvim_create_autocmd(events or { "TextChanged", "TextChangedI", "InsertLeave" }, {
    group    = vim.api.nvim_create_augroup(group_name, { clear = true }),
    pattern  = pattern,
    callback = function() vim.cmd("silent! write") end,
  })
end

return M

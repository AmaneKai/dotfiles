local function harpoon()
  return require("harpoon")
end

local mark_keys = { "<C-h>", "<C-n>", "<C-s>", "<C-t>" }

local keys = {
  { "<leader>a", function() harpoon():list():add() end, desc = "Harpoon Add" },
  { "<C-e>", function() harpoon().ui:toggle_quick_menu(harpoon():list()) end, desc = "Harpoon Menu" },
}

for index, key in ipairs(mark_keys) do
  table.insert(keys, { key, function() harpoon():list():select(index) end, desc = "Harpoon " .. index })
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = keys,
  config = function()
    harpoon():setup()
  end,
}

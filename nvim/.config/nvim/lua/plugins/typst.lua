return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function() require("typst-preview").update() end,
    opts = {
      debug = false,
      dependencies_bin = {
        ["typst-preview"] = nil,
        ["websocat"] = nil,
      },
      get_root = function(path)
        local dir = vim.fn.fnamemodify(path, ":p:h")
        local root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel")[1]
        if root and root ~= "" and vim.v.shell_error == 0 then
          return root
        end
        return dir -- fallback: not in a git repo, just use the file's own directory
      end,
      get_main_file = function(path) return path end,
    },
    config = function(_, opts)
      local preview = require("typst-preview")
      preview.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TypstKeymaps", { clear = true }),
        pattern = "typst",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()

          vim.keymap.set("n", "<leader>ty", "<cmd>TypstPreview<CR>",
            { buffer = buf, desc = "Typst: Start Preview" })
          vim.keymap.set("n", "<leader>tc", "<cmd>TypstPreviewStop<CR>",
            { buffer = buf, desc = "Typst: Stop Preview" })
          vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewSyncCursor<CR>",
            { buffer = buf, desc = "Typst: Sync Cursor" })
        end,
      })

      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
        group    = vim.api.nvim_create_augroup("TypstAutoSave", { clear = true }),
        pattern  = "*.typ",
        callback = function() vim.cmd("silent! write") end,
      })
    end,
  },
}

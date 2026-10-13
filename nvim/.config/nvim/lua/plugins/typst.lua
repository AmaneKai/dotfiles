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
      get_root = function(path) return vim.fn.fnamemodify(path, ":p:h") end,
      get_main_file = function(path) return path end,
    },
    config = function(_, opts)
      require("typst-preview").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TypstKeymaps", { clear = true }),
        pattern = "typst",
        callback = function(ev)
          local buf = ev.buf

          -- autosave every typst buffer so the preview updates as you type
          vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("TypstAutoSave" .. buf, { clear = true }),
            buffer = buf,
            callback = function() vim.cmd("silent! update") end,
          })

          vim.keymap.set("n", "<leader>ty", "<cmd>TypstPreview<CR>",
            { buffer = buf, desc = "Typst: Start Preview" })
          vim.keymap.set("n", "<leader>tc", "<cmd>TypstPreviewStop<CR>",
            { buffer = buf, desc = "Typst: Stop Preview" })
          vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewSyncCursor<CR>",
            { buffer = buf, desc = "Typst: Sync Cursor" })

          -- start the preview as soon as a typst file is opened
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_call(buf, function() vim.cmd("silent! TypstPreview") end)
            end
          end)
        end,
      })
    end,
  },
}

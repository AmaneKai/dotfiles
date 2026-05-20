return {
  {
    "saghen/blink.cmp",
    version = "v0.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "ribru17/blink-cmp-spell",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = { auto_show = true },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = false },
        accept = { auto_brackets = { enabled = false } },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = -3,
          },
        },
      },
      signature = { enabled = true },
    },
  },
}

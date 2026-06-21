return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			python = { "ruff_format" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "prettier", "eslint_d" },
			json = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier" },
		},
	},
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ timeout_ms = 5000, lsp_fallback = false })
			end,
			desc = "Format file",
		},
	},
}

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			json = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 5000,
			lsp_fallback = true,
		},
	},
}

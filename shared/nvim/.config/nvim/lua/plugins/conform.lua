return {
	"stevearc/conform.nvim",
	opts = {
		-- 1. Tell conform which formatter to use for python files.
		formatters_by_ft = {
			python = { "ruff_format", "ruff_organize_imports" }, -- Use the custom formatter defined below
			lua = { "stylua" },
			-- etc.
		},

		-- This will run the formatter on save.
		format_on_save = { timeout_ms = 500 },
	},
}

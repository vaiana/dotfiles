return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = { "ruff", "pyright", "rust_analyzer" },
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}

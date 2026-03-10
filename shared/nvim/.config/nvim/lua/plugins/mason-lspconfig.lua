return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = { "ruff", "pyright" },
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}

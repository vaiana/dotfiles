return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({

			-- This list is now the *only* thing you need in setup()
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },

			-- All other options (highlight, indent, etc.) are
			-- enabled by default in Neovim 0.10+ and removed from this setup table.
			auto_install = true,
		})
	end,
}

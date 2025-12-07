return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Just enable them - that's it!
		vim.lsp.enable("pyright")
		vim.lsp.config("ruff", {
			on_attach = function(client, bufnr)
				-- Disable ruff's formatting (conform will handle that)
				client.server_capabilities.documentFormattingProvider = false
			end,
		})
		vim.lsp.enable("ruff")
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						-- Tell lua_ls that 'vim' is a global variable
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false, -- Disable prompt about luassert/busted
					},
					telemetry = {
						enable = false, -- Don't send usage data
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
	end,
}

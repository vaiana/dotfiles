-- This file is for defining all custom keymaps

vim.g.mapleader = " "

-- format
vim.keymap.set("n", "<leader>fm", function()
	require("conform").format({ async = false, lsp_fallback = true })
end, { desc = "Format buffer" })

-- paste over without deleted content going into buffer : ThePrimagean
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

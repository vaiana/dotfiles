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


-- open links in work browser
vim.keymap.set('n', 'gx', function()
  local url = vim.fn.expand('<cfile>')
  local cmd = 'brave-browser-stable --user-data-dir=$HOME/.config/brave-work/ --class=brave-work "' .. url .. '" &' 
  vim.fn.system(cmd) 
end, { desc = 'Open current url in Brave work env' })

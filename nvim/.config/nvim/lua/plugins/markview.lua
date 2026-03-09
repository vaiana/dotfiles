return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("markview").setup({})

    -- 1. Side-by-Side Toggle (Native)
    -- This uses Markview's internal logic to split the view
    vim.keymap.set("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { 
      desc = "Markdown: Toggle Split Preview" 
    })

    -- 2. Toggle Rendering for current buffer
    -- Useful if you want to quickly see the raw text without splitting
    vim.keymap.set("n", "<leader>mt", "<cmd>Markview toggle<cr>", { 
      desc = "Markdown: Toggle Render" 
    })

    -- 3. Toggle Line Wrap
    -- This is a Neovim-wide setting often essential for Markdown
    vim.keymap.set("n", "<leader>mw", function()
      vim.wo.wrap = not vim.wo.wrap
      -- Optional: cleaner wrapping
      vim.wo.linebreak = true
      local status = vim.wo.wrap and "Enabled" or "Disabled"
      print("Line Wrap: " .. status)
    end, { desc = "Markdown: Toggle Line Wrap" })
  end
}

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
    })

    -- Document existing key chains using the new v3 API
    wk.add({
      { "<leader>e", group = "File explorer" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>h", group = "Git hunks" },
      { "<leader>t", group = "Toggle" },
    })
  end,
}

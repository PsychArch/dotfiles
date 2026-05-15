-- Autocmds are loaded before lazy.nvim startup.

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = vim.api.nvim_create_augroup("trim-whitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close with q",
  group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
  pattern = {
    "help",
    "man",
    "qf",
    "query",
    "checkhealth",
  },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Disable auto-comment on new line
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable auto-comment on new line",
  group = vim.api.nvim_create_augroup("disable-auto-comment", { clear = true }),
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Set tab width for specific file types
vim.api.nvim_create_autocmd("FileType", {
  desc = "Set tab width to 4 for Python files",
  group = vim.api.nvim_create_augroup("python-tab-width", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

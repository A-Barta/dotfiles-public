-- Briefly highlight text after it is yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("bartarian_highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--[[
nvim-treesitter `main` branch.

The old `master` branch is archived and its bundled parsers crash on
neovim 0.11+ (parser ABI mismatch). The `main` branch has a different model:
it no longer drives highlighting itself. Instead we install the parsers and
turn on neovim's built-in treesitter highlighting per filetype.
--]]

-- Parsers to install, paired with the filetypes that should get treesitter
-- highlighting. Note `vimdoc` is the parser for the `help` filetype.
local parsers = { "c", "lua", "vim", "vimdoc", "query", "python" }
local filetypes = { "c", "lua", "vim", "help", "query", "python" }

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- the main branch does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Installs missing parsers asynchronously; no-op for ones already present.
    require("nvim-treesitter").install(parsers)

    -- Start treesitter highlighting when one of these filetypes is opened.
    -- pcall guards the first launch, before async installation has finished.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("bartarian_treesitter", { clear = true }),
      pattern = filetypes,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}

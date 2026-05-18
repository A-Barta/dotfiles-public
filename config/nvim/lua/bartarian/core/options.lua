vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Indentation: 4 spaces, no tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- No line wrapping
opt.wrap = false

-- Search: case-insensitive unless the query has a capital letter
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes" -- always show the sign column so the buffer doesn't shift
opt.cursorline = true
opt.scrolloff = 8 -- keep 8 lines of context above/below the cursor

-- Persistent undo, no swap/backup files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Splits open to the right and below
opt.splitright = true
opt.splitbelow = true

-- Share the system clipboard
opt.clipboard:append("unnamedplus")

-- Snappier UI / completion
opt.updatetime = 250

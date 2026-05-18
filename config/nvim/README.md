# Custom configuration for neovim

This is what I use to configure my neovim.

The setup uses Folke's lazy.nvim as package manager, and William Boman's mason.nvim for lsp.

When typing `<leader>`, which-key pops up a menu of the bindings available from
there, so the lists below are also discoverable in-editor.

## Keybindings

### Global

- `<leader>pv` Go back to directory view
- `<leader>nh` Clear search highlights

### Editing

- `J` / `K` (visual) Move the selection down / up, re-indented
- `J` (normal) Join line below, keeping the cursor in place
- `<C-d>` / `<C-u>` Half-page down / up, keeping the cursor centered
- `n` / `N` Next / previous search result, centered
- `<leader>p` (visual) Paste over the selection without clobbering the register
- `<leader>d` Delete to the black-hole register (keeps the yank register)

### Harpoon

- `<leader>a` Add file to the harpoon menu
- `<C-e>` Toggle harpoon menu
- `<C-1>` Go to file 1 (also works for 2, 3 ... 9, 0)

### Mason and LSP

Completion menu:

- `<C-p>` select previous item
- `<C-n>` select next item
- `<C-y>` apply selected item
- `<C-space>` complete

LSP actions (active in buffers with an attached language server):

- `gd` Go to definition (Telescope)
- `gr` Go to references (Telescope)
- `gi` Go to implementation (Telescope)
- `gD` Go to declaration
- `K` Hover documentation
- `<leader>rn` Rename symbol
- `<leader>ca` Code action
- `<leader>cf` Format buffer
- `[d` / `]d` Previous / next diagnostic
- `<leader>vd` Show diagnostic float

### Git (gitsigns)

Signs for added/changed/removed lines show in the gutter. In a buffer under
version control:

- `]c` / `[c` Next / previous hunk
- `<leader>hs` Stage hunk
- `<leader>hr` Reset hunk
- `<leader>hp` Preview hunk
- `<leader>hb` Blame current line

### Tree (disabled)

The nvim-tree plugin is currently disabled (`enabled = false` in
`plugins/nvim-tree.lua`); netrw is used instead (see `<leader>pv`). These
bindings only apply if the plugin is re-enabled.

- `<leader>ee` toggle nvim tree
- `<leader>ef` toggle nvim tree find file
- `<leader>ec` collapse nvim tree
- `<leader>er` refresh nvim tree

### Telescope

- `<leader>ff` Find files with Telescope
- `<leader>fg` Live grep with telescope
- `<leader>fb` Buffers with telescope
- `<leader>fh` Help tags with telescope

### Trouble

- `<leader>xx` Diagnostics
- `<leader>xX` Buffer diagnostics
- `<leader>cs` Symbols
- `<leader>cl` LSP definitions / references / ...
- `<leader>xL` Location list
- `<leader>xQ` Quickfix list

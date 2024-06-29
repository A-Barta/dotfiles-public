# Custom configuration for neovim

This is what I use to configure my neovim.

The setup uses Folke's lazy.nvim as package manager, and William Boman's mason.nvim for lsp.

## Keybindings

### Global

- `<leader>pv` Go back to directory view
- `<leader>nh` Clear search highlights

### Harpoon

- `<leader>a` Add file to the harpoon menu`
- `<C-e>` Toggle harpoon menu
- `<C-1>` Go to file 1 (also works for 2, 3, 4

### Mason and LSP

- `<C-p>` select previous item
- `<C-n>` select next item
- `<C-y>` apply selected item
- `<C-space>` complete

### Tree

- `<leader>ee` toggle nvim tree
- `<leader>ef` toggle nvim tree find file
- `<leader>ec` collapse nvim tree
- `<leader>er` refresh nvim tree

### Telescope

- `<leader>ff` Find files with Telescope
- `<leader>fg` Live grep with telescope
- `<leader>fb` Buffers with telescope
- `<leader>fh` Help tags with telescope

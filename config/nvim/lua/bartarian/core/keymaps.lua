local keymap = vim.keymap

keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Go back to directory view" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Move the selected lines up/down, re-indented to context
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join lines without moving the cursor to the end
keymap.set("n", "J", "mzJ`z", { desc = "Join line, keep cursor" })

-- Keep the cursor centered while scrolling and searching
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })
keymap.set("n", "n", "nzzzv", { desc = "Next search result, centered" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev search result, centered" })

-- Paste over a selection without clobbering the yank register
keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection, keep register" })

-- Delete to the black-hole register (don't touch the yank register)
keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

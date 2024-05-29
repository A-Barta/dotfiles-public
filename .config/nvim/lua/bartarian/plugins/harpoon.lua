return {
  "theprimeagen/harpoon",
  config = function()
    require("harpoon.mark")
    require("harpoon.ui")
  end,
  keys = {
    {'<leader>a', mode = 'n', '<cmd>lua require("harpoon.mark").add_file()<cr>', desc = 'Harpoon - mark a file'},
    {'<C-e>', mode = 'n', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', desc = 'Harpoon - quick menu'},
    {'<C-1>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', desc = 'Harpoon - goto file 1'},
    {'<C-2>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', desc = 'Harpoon - goto file 2'},
    {'<C-3>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', desc = 'Harpoon - goto file 3'},
    {'<C-4>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', desc = 'Harpoon - goto file 4'},
  }
}

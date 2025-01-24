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
    {'<C-5>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', desc = 'Harpoon - goto file 5'},
    {'<C-6>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', desc = 'Harpoon - goto file 6'},
    {'<C-7>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(7)<cr>', desc = 'Harpoon - goto file 7'},
    {'<C-8>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(8)<cr>', desc = 'Harpoon - goto file 8'},
    {'<C-9>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(9)<cr>', desc = 'Harpoon - goto file 9'},
    {'<C-0>', mode = 'n', '<cmd>lua require("harpoon.ui").nav_file(10)<cr>', desc = 'Harpoon - goto file 10'},
  }
}

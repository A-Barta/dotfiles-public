return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sharkdp/fd',
  },
  config = function()
    require("telescope").load_extension('harpoon')
  end,
  keys = {
    {'<leader>ff', mode = 'n', '<cmd>Telescope find_files<cr>', desc = 'Find files with Telescope'},
    {'<leader>fg', mode = 'n', '<cmd>Telescope live_grep<cr>', desc = 'Live grep with telescope'},
    {'<leader>fb', mode = 'n', '<cmd>Telescope buffers<cr>', desc = 'Buffers with telescope'},
    {'<leader>fh', mode = 'n', '<cmd>Telescope help_tags<cr>', desc = 'Help tags with telescope'},
  }
}

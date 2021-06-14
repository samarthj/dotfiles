-- Telescope ---------------------------------------
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
map('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<C-q>', '<cmd>lua require("telescope.builtin").file_browser()<cr>')
map('n', '<C-b>', '<cmd>lua require("telescope.builtin").buffers()<cr>')
map('n', '<C-s>', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', '<C-f>', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>')
map('n', '<C-o>', '<cmd>lua require("telescope.builtin").treesitter()<cr>')
map('n', '<C-j>', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
map('n', '<C-a>', '<cmd>lua require("telescope.builtin").builtins()<cr>')

-- Telescope ---------------------------------------
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- Find file in current dir
map('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<cr>')
-- Only works in the previous scope, .... forgot why this was useful, removing for now
-- -- -- map('n', '<C-q>', '<cmd>lua require("telescope.builtin").file_browser()<cr>')
-- Find text in file in current dir
map('n', '<C-s>', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
-- Switch between files in the current session
map('n', '<C-b>', '<cmd>lua require("telescope.builtin").buffers()<cr>')
-- Search current file
map('n', '<C-f>', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>')
-- Cycle through treesitter AST collected references
map('n', '<C-o>', '<cmd>lua require("telescope.builtin").treesitter()<cr>')
-- Cycle through lsp references of current selection
map('n', '<C-j>', '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
-- Broken? (or forgot what this was for)
-- map('n', '<C-a>', '<cmd>lua require("telescope.builtin").builtins()<cr>')

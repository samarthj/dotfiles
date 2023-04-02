local telescope = require('telescope')
local u = require 'utils'.u
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")

local ignore_large_files = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end
local Job = require("plenary.job")
local ignore_binaries = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        ignore_large_files(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end
local custom_prieview_maker = ignore_binaries

telescope.setup {
  defaults = {
    sorting_strategy = 'ascending',
    prompt_prefix = u 'f002' .. ' ',
    layout_config = {
      prompt_position = 'top',
    },
    selection_caret = u 'f054' .. ' ',
    color_devicons = true,
    scroll_strategy = 'cycle',
    buffer_previewer_maker = custom_prieview_maker,
    mappings = {
      -- map actions.which_key to <C-h> (default: <C-/>)
      -- actions.which_key shows the mappings for your picker,
      -- e.g. git_{create, delete, ...}_branch for the git_branches picker
      i = {
        ['<C-K>'] = actions.move_selection_previous,
        ['<C-J>'] = actions.move_selection_next,
        ['<Esc>'] = actions.close
      }
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim" -- add this value
    }
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
  }
}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"

local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


local function switcher()
  local mini = {
    layout_strategy = 'vertical',
    layout_config = {
      height = 0.5,
      width = 0.3,
    }
  }

  local function set_theme()
    local selected = action_state.get_selected_entry()[1]
    local cmd = 'colorscheme ' .. selected
    vim.cmd(cmd)
  end

  local function write_config()
    local selected = action_state.get_selected_entry()[1]
    local theme_path = vim.fn.stdpath "config/lua" .. "/current-theme.lua"
    file = io.open(theme_path, "w")
    file:write('vim.cmd(colorscheme ' .. selected .. ')')
    file:close()
  end

  local colors = vim.fn.getcompletion('', 'color')


  local picker_opts = {
    prompt_title = "Theme Switcher",
    -- previewer = previewer,
    finder = finders.new_table(colors),
    sorter = sorters.get_generic_fuzzy_sorter({}),
    sorting_strategy = 'ascending',


    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        set_theme()
        write_config()
        actions.close(prompt_bufnr)
      end)

      -- reload theme on cycling
      map("i", "<Down>", function()
        actions.move_selection_next(prompt_bufnr)
        set_theme()
      end)

      map("i", "<Up>", function()
        actions.move_selection_previous(prompt_bufnr)
        set_theme()
      end)

      return true
    end,
  }

  local picker = pickers.new(mini, picker_opts)
  picker:find()
end

return require("telescope").register_extension {
  exports = { themes = switcher },
}

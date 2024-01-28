local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function switcher(opts)
	local function set_theme()
		vim.cmd("colorscheme " .. action_state.get_selected_entry()[1])
	end

	local function write_config()
		local selected = action_state.get_selected_entry()[1]
		local theme_path = vim.fn.stdpath("config") .. "/lua/current-theme.lua"
		file = io.open(theme_path, "w")
		file:write('vim.cmd("colorscheme ' .. selected .. '")')
		file:close()
	end

	local colors = vim.fn.getcompletion("", "color")
	local bufnr = vim.api.nvim_get_current_buf()

	local previewer = previewers.new_buffer_previewer({
		define_preview = function(self, entry)
			-- add content
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

			-- add syntax highlighting in previewer
			local ft = (vim.filetype.match({ buf = bufnr }) or "diff"):match("%w+")
			require("telescope.previewers.utils").highlighter(self.state.bufnr, ft)
		end,
	})

	local picker_opts = {
		prompt_title = "Themes",
		previewer = previewer,
		finder = finders.new_table(colors),
		sorter = sorters.get_generic_fuzzy_sorter(opts),
		sorting_strategy = "ascending",

		attach_mappings = function(prompt_bufnr, map)
			map("i", "<CR>", function()
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

	local picker = pickers.new(opts, picker_opts)
	picker:find()
end

return require("telescope").register_extension({
	exports = { themes = switcher },
})

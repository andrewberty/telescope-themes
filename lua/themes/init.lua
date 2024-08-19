local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local themes = {}

local set_theme = function()
	vim.cmd("colorscheme " .. action_state.get_selected_entry()[1])
end

local getAllThemes = function()
	return vim.fn.getcompletion("", "color", true)
end

-- filter according keywords
local isInKeywords = function(theme, keywords)
	for _, keyword in ipairs(keywords) do
		if string.find(theme, keyword) then
			return true
		end
	end
	return false
end

local light_themes = function()
	local filtered = {}
	for _, theme in ipairs(getAllThemes()) do
		if isInKeywords(theme, themes.config.light_themes.keywords) then
			table.insert(filtered, theme)
		end
	end
	return filtered
end

local dark_themes = function()
	local filtered = {}
	for _, theme in ipairs(getAllThemes()) do
		if isInKeywords(theme, themes.config.dark_themes.keywords) then
			table.insert(filtered, theme)
		end
	end
	return filtered
end

-- Filter installed themes from ignored themes
local filtered_colors = function()
	local ignore_table = {}

	if themes.config.ignore then
		vim.list_extend(ignore_table, themes.config.ignore)
	end

	if themes.config.light_themes and themes.config.light_themes.ignore then
		vim.list_extend(ignore_table, light_themes())
	end

	if themes.config.dark_themes and themes.config.dark_themes.ignore then
		vim.list_extend(ignore_table, dark_themes())
	end

	local filtered = {}
	for _, theme in ipairs(getAllThemes()) do
		if not vim.tbl_contains(ignore_table, theme) then
			table.insert(filtered, theme)
		end
	end

	return filtered
end

-- Write config to `current-theme.lua` to persist theme
local write_config = function()
	local path = themes.config.persist.path
	local selected = action_state.get_selected_entry()[1]
	local file = assert(io.open(path, "w"))

	file:write('vim.cmd("colorscheme ' .. selected .. '")')
	file:close()
end

-- Provide buffer previewer with syntax highlighting
local get_previewer = function()
	local bufnr = vim.api.nvim_get_current_buf()

	if themes.config.enable_previewer == true then
		return previewers.new_buffer_previewer({
			define_preview = function(self, _)
				-- Add content
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

				-- Syntax highlighting
				local ft = (vim.filetype.match({ buf = bufnr }) or "diff"):match("%w+")
				require("telescope.previewers.utils").highlighter(self.state.bufnr, ft)
			end,
		})
	else
		return nil
	end
end

-- Picker
themes.switcher = function(func_opts)
	local old_theme = vim.g.colors_name or "default"

	local picker_opts = {
		prompt_title = "Themes",
		previewer = get_previewer(),
		finder = finders.new_table(filtered_colors()),
		sorter = sorters.get_generic_fuzzy_sorter(themes.config),
		attach_mappings = function(prompt_bufnr, map)
			map("i", themes.config.mappings.accept, function()
				set_theme()
				if themes.config.persist.enabled then
					write_config()
				end
				actions.close(prompt_bufnr)
			end)
			map("i", themes.config.mappings.down, function()
				actions.move_selection_next(prompt_bufnr)
				if themes.config.enable_live_preview == true then
					set_theme()
				end
			end)
			map("i", "<Tab>", function()
				actions.move_selection_next(prompt_bufnr)
				if themes.config.enable_live_preview == true then
					set_theme()
				end
			end)
			map("i", themes.config.mappings.up, function()
				actions.move_selection_previous(prompt_bufnr)
				if themes.config.enable_live_preview == true then
					set_theme()
				end
			end)
			map("i", "<S-Tab>", function()
				actions.move_selection_previous(prompt_bufnr)
				if themes.config.enable_live_preview == true then
					set_theme()
				end
			end)
			map("i", "<ESC>", function()
				vim.cmd("colorscheme " .. old_theme)
				actions.close(prompt_bufnr)
			end)
			map("i", "<C-c>", function()
				vim.cmd("colorscheme " .. old_theme)
				actions.close(prompt_bufnr)
			end)
			return true
		end,
	}

	-- Merge picker opts with all config
	local temp_opts = vim.tbl_deep_extend("force", themes.config, picker_opts)
	local opts = vim.tbl_deep_extend("force", temp_opts, func_opts)
	local picker = pickers.new(opts)

	picker:find()
end

return themes

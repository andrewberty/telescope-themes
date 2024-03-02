-- Check if telescope is installed
local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
	error("telescope-themes requires nvim-telescope/telescope.nvim")
end

local themes = require("themes.init")
local config = require("themes.config")

return telescope.register_extension({
	setup = function(ext_config, telescope_config)
		-- Merge default extension config with user extension config and telescope config
		if ext_config then
			local extension_config = vim.tbl_deep_extend("force", config.default_config, ext_config)
			themes.config = vim.tbl_deep_extend("force", telescope_config, extension_config)

		-- Merge default extension config with telescope config
		else
			themes.config = vim.tbl_deep_extend("force", telescope_config, config.default_config)
		end
	end,
	exports = { themes = themes.switcher },
})

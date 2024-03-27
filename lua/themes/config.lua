local M = {}

M.default_config = {
	ignore = {
		"default",
		"vim",
		"retrobox",
		"sorbet",
		"wildcharm",
		"zaibatsu",
		"desert",
		"evening",
		"industry",
		"koehler",
		"morning",
		"murphy",
		"pablo",
		"peachpuff",
		"ron",
		"shine",
		"slate",
		"torte",
		"zellner",
		"blue",
		"darkblue",
		"delek",
		"quiet",
		"elflord",
		"habamax",
		"lunaperche",
	},
	enable_live_preview = true,
	enable_previewer = true,
	persist = {
		enabled = true,
		path = vim.fn.stdpath("config") .. "/lua/current-theme.lua",
	},
}

return M

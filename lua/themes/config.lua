local M = {}

M.builtin_schemes = {
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
}
M.light_keywords = { "light", "day" }
M.dark_keywords = { "black", "night", "dark" }

M.default_config = {
	ignore = M.builtin_schemes,
	light_themes = {
		ignore = false,
		keywords = M.light_keywords,
	},
	dark_themes = {
		ignore = false,
		keywords = M.dark_keywords,
	},
	enable_live_preview = true,
	enable_previewer = true,
	persist = {
		enabled = true,
		path = vim.fn.stdpath("config") .. "/lua/current-theme.lua",
	},
	mappings = {
		down = "<Down>",
		up = "<Up>",
		accept = "<CR>",
	},
}

return M

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

M.default_config = {
	ignore = M.builtin_schemes,
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

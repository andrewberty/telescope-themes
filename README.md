# Telescope Themes

An extension for Telescope plugin to switch colorschemes with preview. It will read all your installed themes (in addition to nvim builtin themes) and

![demo](assets/telescope-themes.png)

## Installation

1. Plugins config file

Using [packer.nvim](https://github.com/wbthomason/packer.nvim) or [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
use {
	'andrew-george/telescope-themes',
	config = function()
		require('telescope').load_extension('themes')
	end
}
```

2. As a dependancy in telescope config file (example in lazy.nvim)

```lua
{
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    lazy = true,
    dependencies = {
		'andrew-george/telescope-themes',
		-- your other dependencies
    },
    config = function()
	    -- load extension
	    local telescope = require('telescope')
	    telescope.load_extension('themes')
    end
},
```

## Usage

```lua
:Telescope themes
```

or map it to a key
```lua
vim.keymap.set("n", "<leader>th", ":Telescope themes<CR>", {noremap = true, silent = true})
```

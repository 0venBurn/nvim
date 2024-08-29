-- return {
-- 	-- https://github.com/folke/tokyonight.nvim
-- 	"folke/tokyonight.nvim", -- You can replace this with your favorite colorschemecolor
-- 	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
-- 	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
-- 	opts = {
-- 		-- Replace this with your scheme-specific settings or remove to use the defaults
-- 		transparent = true,
-- 		style = "night", -- other variations "storm, night, moon, day"
-- 		styles = {
-- 			sidebars = "transparent",
-- 			floats = "transparent",
-- 		},
-- 	},
-- 	config = function(_, opts)
-- 		require("tokyonight").setup(opts) -- Replace this with your favorite colorscheme
-- 		vim.cmd("colorscheme tokyonight") -- Replace this with your favorite colorscheme
-- 	end,
-- }
-- -- -- return {

-- -- 	"rose-pine/neovim",
-- -- 	lazy = false,
-- -- 	priority = 1000,
-- -- 	config = function()
-- -- 		vim.cmd.colorscheme("rosepine")
-- -- 	end,
-- -- }

-- return {
-- 	"olimorris/onedarkpro.nvim",
-- 	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
-- 	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
-- 	opts = {
-- 		cursorline = "#FF0000", -- other variations: onelight, onedark_vivid, onedark_dark
-- 	},
-- 	config = function(_, opts)
-- 		require("onedarkpro").setup({
-- 			options = {
-- 				transparency = true, -- Enable transparency here
-- 			},
-- 			cursorline = "#FF0000", -- You can also specify cursorline color here if needed
-- 		})
-- 		vim.cmd("colorscheme onedark") -- Apply the colorscheme
-- 	end,
-- }
-- Catppuccin Theme
-- return {
-- 	-- https://github.com/catppuccin/nvim
-- 	"catppuccin/nvim",
-- 	name = "catppuccin", -- name is needed otherwise plugin shows up as "nvim" due to github URI
-- 	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
-- 	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
-- 	opts = {
-- 		-- Replace this with your scheme-specific settings or remove to use the defaults
-- 		transparent = true,
-- 		flavour = "mocha", -- "latte, frappe, macchiato, mocha"
-- 	},
-- 	config = function(_, opts)
-- 		require("catppuccin").setup(opts) -- Replace this with your favorite colorscheme
-- 		vim.cmd("colorscheme catppuccin") -- Replace this with your favorite colorscheme
-- 	end,
-- }

-- Sonokai Theme
-- return {
-- 	-- https://github.com/sainnhe/sonokai
-- 	"sainnhe/sonokai",
-- 	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
-- 	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
-- 	config = function(_, opts)
-- 		vim.g.sonokai_style = "default" -- "default, atlantis, andromeda, shusia, maia, espresso"
-- 		vim.cmd("colorscheme sonokai") -- Replace this with your favorite colorscheme
-- 	end,
-- }

-- One Nord Theme
-- return {
-- 	-- https://github.com/rmehri01/onenord.nvim
-- 	"rmehri01/onenord.nvim",
-- 	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
-- 	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
-- 	config = function(_, opts)
-- 		vim.cmd("colorscheme onenord") -- Replace this with your favorite colorscheme
-- 	end,
-- Gruvbox Theme
return {
	-- https://github.com/ellisonleao/gruvbox.nvim
	"ellisonleao/gruvbox.nvim",
	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
	config = function()
		require("gruvbox").setup({
			terminal_colors = true, -- add neovim terminal colors
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = true,
		})
		vim.cmd("colorscheme gruvbox")
	end,
}

----return {
----	{
----		"rose-pine/neovim",
----		name = "rose-pine",
----		priority = 1000,
----		config = function()
----			require("rose-pine").setup({
----				variant = "auto", -- auto, main, moon, or dawn
----				dark_variant = "main", -- main, moon, or dawn
----				dim_inactive_windows = false,
----				extend_background_behind_borders = true,

----				enable = {
----					terminal = true,
----					legacy_highlights = true,
----					migrations = true,
----				},

----				styles = {
----					bold = true,
----					italic = true,
----					transparency = true,
----				},

----				groups = {
----					border = "muted",
----					link = "iris",
----					panel = "surface",

----					error = "love",
----					hint = "iris",
----					info = "foam",
----					note = "pine",
----					todo = "rose",
----					warn = "gold",

----					git_add = "foam",
----					git_change = "rose",
----					git_delete = "love",
----					git_dirty = "rose",
----					git_ignore = "muted",
----					git_merge = "iris",
----					git_rename = "pine",
----					git_stage = "iris",
----					git_text = "rose",
----					git_untracked = "subtle",

----					h1 = "iris",
----					h2 = "foam",
----					h3 = "rose",
----					h4 = "gold",
----					h5 = "pine",
----					h6 = "foam",
----				},

----				palette = {
----					-- Override the builtin palette per variant
----					-- moon = {
----					--     base = '#18191a',
----					--     overlay = '#363738',
----					-- },
----				},

----				highlight_groups = {
----					-- Comment = { fg = "foam" },
----					-- VertSplit = { fg = "muted", bg = "muted" },
----				},

----				before_highlight = function(group, highlight, palette)
----					-- Disable all undercurls
----					-- if highlight.undercurl then
----					--     highlight.undercurl = false
----					-- end
----					--
----					-- Change palette colour
----					-- if highlight.fg == palette.pine then
----					--     highlight.fg = palette.foam
----					-- end
----				end,
----			})

----			vim.cmd.colorscheme("rose-pine")
----		end,
----	},
----}

-- return {
-- 	{
-- 		"catppuccin/nvim",
-- 		name = "catppuccin",
-- 		priority = 1000,
-- 		config = function()
-- 			require("catppuccin").setup({
-- 				flavour = "mocha", -- latte, frappe, macchiato, mocha
-- 				background = {
-- 					light = "latte",
-- 					dark = "mocha",
-- 				},
-- 				transparent_background = true, -- enables transparent background
-- 				show_end_of_buffer = false,
-- 				term_colors = false,
-- 				dim_inactive = {
-- 					enabled = false,
-- 					shade = "dark",
-- 					percentage = 0.15,
-- 				},
-- 				no_italic = false,
-- 				no_bold = false,
-- 				no_underline = false,
-- 				styles = {
-- 					comments = { "italic" },
-- 					conditionals = { "italic" },
-- 					loops = {},
-- 					functions = {},
-- 					keywords = {},
-- 					strings = {},
-- 					variables = {},
-- 					numbers = {},
-- 					booleans = {},
-- 					properties = {},
-- 					types = {},
-- 					operators = {},
-- 				},
-- 				color_overrides = {},
-- 				custom_highlights = {},
-- 				default_integrations = true,
-- 				integrations = {
-- 					cmp = true,
-- 					gitsigns = true,
-- 					nvimtree = true,
-- 					treesitter = true,
-- 					notify = false,
-- 					mini = {
-- 						enabled = true,
-- 						indentscope_color = "",
-- 					},
-- 				},
-- 			})

-- 			-- Apply the colorscheme
-- 			vim.cmd.colorscheme("catppuccin")

-- 			-- Set opacity to 0.9
-- 			vim.o.background = "light"
-- 			vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
-- 			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
-- 		end,
-- 	},
-- }

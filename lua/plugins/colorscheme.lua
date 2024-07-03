-- return {
-- 	-- https://github.com/folke/tokyonight.nvim
-- 	"folke/tokyonight.nvim", -- You can replace this with your favorite colorscheme
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
-- return {
-- 	"Alexis12119/nightly.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("nightly").setup({
-- 			transparent = true,
-- 			styles = {
-- 				comments = { italic = true },
-- 				functions = { italic = false },
-- 				variables = { italic = false },
-- 				keywords = { italic = false },
-- 			},
-- 			highlights = {},
-- 		})
-- 		vim.cmd.colorscheme("nightly")
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

return {
	"olimorris/onedarkpro.nvim",
	lazy = false, -- We want the colorscheme to load immediately when starting Neovim
	priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
	opts = {
		cursorline = "#FF0000", -- other variations: onelight, onedark_vivid, onedark_dark
	},
	config = function(_, opts)
		require("onedarkpro").setup({
			options = {
				transparency = true, -- Enable transparency here
			},
			cursorline = "#FF0000", -- You can also specify cursorline color here if needed
		})
		vim.cmd("colorscheme onedark") -- Apply the colorscheme
	end,
}
-- Catppuccin Theme
-- return {
--   -- https://github.com/catppuccin/nvim
--   'catppuccin/nvim',
--   name = "catppuccin", -- name is needed otherwise plugin shows up as "nvim" due to github URI
--   lazy = false, -- We want the colorscheme to load immediately when starting Neovim
--   priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
--   opts = {
--   --   -- Replace this with your scheme-specific settings or remove to use the defaults
--     -- transparent = true,
--     flavour = "mocha", -- "latte, frappe, macchiato, mocha"
--   },
--   config = function(_, opts)
--     require('catppuccin').setup(opts) -- Replace this with your favorite colorscheme
--     vim.cmd("colorscheme catppuccin") -- Replace this with your favorite colorscheme
--   end
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
-- }

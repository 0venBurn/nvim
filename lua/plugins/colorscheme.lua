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
--Gruvbox Theme
return {
  -- https://github.com/ellisonleao/gruvbox.nvim
  "ellisonleao/gruvbox.nvim",
  lazy = false,    -- We want the colorscheme to load immediately when starting Neovim
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
      contrast = "",  -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = true,
    })
    vim.cmd("colorscheme gruvbox")
  end,
}

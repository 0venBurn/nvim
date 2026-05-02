-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.highlightedyank_highlight_duration = 1000
vim.opt.completeopt:append({ "noinsert", "popup" })

-- Persistent LSP on/off switch. Commands: :LspOn, :LspOff, :LspToggle, :LspStatus
require("core.lsp-toggle").setup()

-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
	change_detection = {
		enabled = true, -- automatically check for config file changes and reload the ui
		notify = false, -- turn off notifications whenever plugin changes are made
	},
})

-- These modules are not loaded by lazy
require("core.options")
require("core.autocmds")
require("core.keymaps")

vim.cmd.colorscheme("cuimhne")

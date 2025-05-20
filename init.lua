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
-- This has to be set before initializing lazy
-- Define an autocommand group
local augroup_name = "MyHighlightYankGroup"
vim.api.nvim_exec([[
  augroup !]] .. augroup_name .. [[
    autocmd!
]], false)

-- Add the autocommand
vim.api.nvim_exec(
    [[
  autocmd TextYankPost * silent lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
]],
    false
)
vim.g.mapleader = " "
vim.g.highlightedyank_highlight_duration = 1000
vim.opt.completeopt:append({ "noinsert", "popup" })
-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
    change_detection = {
        enabled = true, -- automatically check for config file changes and reload the ui
        notify = false, -- turn off notifications whenever plugin changes are made
    },
})

-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")

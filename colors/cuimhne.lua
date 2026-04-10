-- Warm dark colorscheme for Neovim
-- Candlelight on aged linen. Not a terminal.

vim.cmd("highlight clear")
vim.g.colors_name = "cuimhne"

local bg0 = "#1A1714"
local bg1 = "#242019"
local bg2 = "#2E2921"
local bg3 = "#332E27"
local bg4 = "#3D3830"

local fg0 = "#F0EBE1"
local fg1 = "#D4CEC6"
local fg2 = "#9C9488"
local fg3 = "#6B6560"

local green = "#7FA688"
local green_d = "#5C7A64"
local sage = "#A8B898"
local terra = "#C47A5A"
local terra_d = "#A05C4A"
local gold = "#C4A882"
local gold_d = "#A8855A"
local linen = "#B8A898"
local mist = "#8FA89C"

local hl = vim.api.nvim_set_hl

-- Editor
hl(0, "Normal", { fg = fg0, bg = bg0 })
hl(0, "NormalFloat", { fg = fg0, bg = bg2 })
hl(0, "NormalNC", { fg = fg1, bg = bg0 })
hl(0, "SignColumn", { fg = fg2, bg = bg0 })
hl(0, "LineNr", { fg = bg3, bg = bg0 })
hl(0, "CursorLineNr", { fg = fg2, bg = bg0, bold = true })
hl(0, "CursorLine", { bg = bg1 })
hl(0, "ColorColumn", { bg = bg1 })
hl(0, "Folded", { fg = fg3, bg = bg1, italic = true })
hl(0, "FoldColumn", { fg = bg3, bg = bg0 })
hl(0, "VertSplit", { fg = bg3, bg = bg0 })
hl(0, "WinSeparator", { fg = bg3, bg = bg0 })
hl(0, "EndOfBuffer", { fg = bg2 })
hl(0, "NonText", { fg = bg3 })
hl(0, "SpecialKey", { fg = bg3 })
hl(0, "Whitespace", { fg = bg3 })
hl(0, "Conceal", { fg = fg3 })

hl(0, "RenderMarkdownCode", { bg = bg0 })

-- Selection & Search
hl(0, "Visual", { bg = bg4 })
hl(0, "VisualNOS", { bg = bg3 })
hl(0, "Search", { fg = bg0, bg = gold })
hl(0, "IncSearch", { fg = bg0, bg = terra })
hl(0, "CurSearch", { fg = bg0, bg = gold })
hl(0, "Substitute", { fg = bg0, bg = terra })

-- Statusline
hl(0, "StatusLine", { fg = fg1, bg = bg2 })
hl(0, "StatusLineNC", { fg = fg3, bg = bg1 })
hl(0, "WildMenu", { fg = bg0, bg = green })
hl(0, "TabLine", { fg = fg2, bg = bg1 })
hl(0, "TabLineSel", { fg = fg0, bg = bg3 })
hl(0, "TabLineFill", { bg = bg1 })

-- Pmenu
hl(0, "Pmenu", { fg = fg1, bg = bg2 })
hl(0, "PmenuSel", { fg = fg0, bg = bg4 })
hl(0, "PmenuSbar", { bg = bg2 })
hl(0, "PmenuThumb", { bg = bg3 })
hl(0, "FloatBorder", { fg = bg3, bg = bg2 })
hl(0, "FloatTitle", { fg = sage, bg = bg2 })

-- Messages
hl(0, "ErrorMsg", { fg = terra, bold = true })
hl(0, "WarningMsg", { fg = gold })
hl(0, "MoreMsg", { fg = green })
hl(0, "ModeMsg", { fg = fg2 })
hl(0, "Question", { fg = sage })

-- Syntax
hl(0, "Comment", { fg = fg3, italic = true })
hl(0, "Constant", { fg = gold })
hl(0, "String", { fg = gold, italic = true })
hl(0, "Character", { fg = gold })
hl(0, "Number", { fg = gold_d })
hl(0, "Boolean", { fg = terra })
hl(0, "Float", { fg = gold_d })
hl(0, "Identifier", { fg = fg0 })
hl(0, "Function", { fg = mist })
hl(0, "Statement", { fg = green_d, bold = true })
hl(0, "Conditional", { fg = green_d, bold = true })
hl(0, "Repeat", { fg = green_d, bold = true })
hl(0, "Label", { fg = green })
hl(0, "Operator", { fg = sage })
hl(0, "Keyword", { fg = green_d, bold = true })
hl(0, "Exception", { fg = terra, bold = true })
hl(0, "PreProc", { fg = linen })
hl(0, "Include", { fg = linen })
hl(0, "Define", { fg = linen })
hl(0, "Macro", { fg = linen })
hl(0, "PreCondit", { fg = linen })
hl(0, "Type", { fg = linen })
hl(0, "StorageClass", { fg = linen })
hl(0, "Structure", { fg = linen })
hl(0, "Typedef", { fg = linen })
hl(0, "Special", { fg = sage })
hl(0, "SpecialChar", { fg = sage })
hl(0, "Tag", { fg = terra })
hl(0, "Delimiter", { fg = fg2 })
hl(0, "SpecialComment", { fg = fg2, italic = true })
hl(0, "Debug", { fg = terra })
hl(0, "Underlined", { underline = true })
hl(0, "Ignore", { fg = bg3 })
hl(0, "Error", { fg = terra, bold = true })
hl(0, "Todo", { fg = bg0, bg = gold, bold = true })

-- Treesitter
hl(0, "@comment", { link = "Comment" })
hl(0, "@variable", { fg = fg0 })
hl(0, "@variable.builtin", { fg = terra })
hl(0, "@variable.parameter", { fg = fg1 })
hl(0, "@variable.member", { fg = fg0 })
hl(0, "@constant", { fg = gold })
hl(0, "@constant.builtin", { fg = gold, bold = true })
hl(0, "@constant.macro", { fg = linen })
hl(0, "@string", { fg = gold, italic = true })
hl(0, "@string.escape", { fg = sage })
hl(0, "@number", { fg = gold_d })
hl(0, "@boolean", { fg = terra })
hl(0, "@float", { fg = gold_d })
hl(0, "@function", { fg = mist })
hl(0, "@function.builtin", { fg = mist, italic = true })
hl(0, "@function.call", { fg = mist })
hl(0, "@function.macro", { fg = linen })
hl(0, "@function.method", { fg = mist })
hl(0, "@function.method.call", { fg = mist })
hl(0, "@constructor", { fg = linen })
hl(0, "@keyword", { fg = green_d, bold = true })
hl(0, "@keyword.function", { fg = green_d, bold = true })
hl(0, "@keyword.return", { fg = terra, bold = true })
hl(0, "@keyword.operator", { fg = sage })
hl(0, "@keyword.import", { fg = linen })
hl(0, "@keyword.conditional", { fg = green_d, bold = true })
hl(0, "@keyword.repeat", { fg = green_d, bold = true })
hl(0, "@keyword.exception", { fg = terra, bold = true })
hl(0, "@type", { fg = linen })
hl(0, "@type.builtin", { fg = linen, italic = true })
hl(0, "@type.definition", { fg = linen })
hl(0, "@attribute", { fg = sage })
hl(0, "@property", { fg = fg1 })
hl(0, "@operator", { fg = sage })
hl(0, "@punctuation", { fg = fg2 })
hl(0, "@punctuation.bracket", { fg = fg2 })
hl(0, "@punctuation.delimiter", { fg = fg2 })
hl(0, "@tag", { fg = terra })
hl(0, "@tag.attribute", { fg = sage })
hl(0, "@tag.delimiter", { fg = fg3 })
hl(0, "@markup.heading", { fg = green, bold = true })
hl(0, "@markup.link", { fg = mist, underline = true })
hl(0, "@markup.link.url", { fg = sage, underline = true })
hl(0, "@markup.raw", { fg = gold })
hl(0, "@markup.strong", { bold = true })
hl(0, "@markup.italic", { italic = true })
hl(0, "@markup.list", { fg = terra })

-- LSP
hl(0, "DiagnosticError", { fg = terra })
hl(0, "DiagnosticWarn", { fg = gold })
hl(0, "DiagnosticInfo", { fg = sage })
hl(0, "DiagnosticHint", { fg = mist })
hl(0, "DiagnosticOk", { fg = green })
hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = terra })
hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = gold })
hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = sage })
hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = mist })
hl(0, "LspReferenceText", { bg = bg3 })
hl(0, "LspReferenceRead", { bg = bg3 })
hl(0, "LspReferenceWrite", { bg = bg4 })
hl(0, "LspInlayHint", { fg = fg3, bg = bg1, italic = true })

-- Git
hl(0, "DiffAdd", { fg = green, bg = bg1 })
hl(0, "DiffChange", { fg = gold, bg = bg1 })
hl(0, "DiffDelete", { fg = terra, bg = bg1 })
hl(0, "DiffText", { fg = bg0, bg = gold })
hl(0, "GitSignsAdd", { fg = green })
hl(0, "GitSignsChange", { fg = gold })
hl(0, "GitSignsDelete", { fg = terra })

-- Telescope
hl(0, "TelescopeNormal", { fg = fg1, bg = bg1 })
hl(0, "TelescopeBorder", { fg = bg3, bg = bg1 })
hl(0, "TelescopePromptNormal", { fg = fg0, bg = bg2 })
hl(0, "TelescopePromptBorder", { fg = bg3, bg = bg2 })
hl(0, "TelescopePromptTitle", { fg = bg0, bg = green })
hl(0, "TelescopePreviewTitle", { fg = bg0, bg = sage })
hl(0, "TelescopeResultsTitle", { fg = fg3, bg = bg1 })
hl(0, "TelescopeSelection", { bg = bg4 })
hl(0, "TelescopeMatching", { fg = gold, bold = true })

-- Neo-tree
hl(0, "NeoTreeNormal", { fg = fg1, bg = bg1 })
hl(0, "NeoTreeNormalNC", { fg = fg2, bg = bg1 })
hl(0, "NeoTreeRootName", { fg = green, bold = true })
hl(0, "NeoTreeDirectoryName", { fg = fg1 })
hl(0, "NeoTreeFileName", { fg = fg1 })
hl(0, "NeoTreeGitAdded", { fg = green })
hl(0, "NeoTreeGitModified", { fg = gold })
hl(0, "NeoTreeGitDeleted", { fg = terra })
hl(0, "NeoTreeIndentMarker", { fg = bg3 })
hl(0, "NeoTreeWinSeparator", { fg = bg3, bg = bg1 })

-- Which-key
hl(0, "WhichKey", { fg = sage })
hl(0, "WhichKeyGroup", { fg = green })
hl(0, "WhichKeyDesc", { fg = fg1 })
hl(0, "WhichKeyBorder", { fg = bg3 })
hl(0, "WhichKeyFloat", { bg = bg2 })

-- Indent blankline
hl(0, "IblIndent", { fg = bg2 })
hl(0, "IblScope", { fg = bg3 })

-- nvim-cmp
hl(0, "CmpItemAbbr", { fg = fg1 })
hl(0, "CmpItemAbbrMatch", { fg = gold, bold = true })
hl(0, "CmpItemAbbrMatchFuzzy", { fg = gold })
hl(0, "CmpItemKind", { fg = sage })
hl(0, "CmpItemMenu", { fg = fg3 })
hl(0, "CmpNormal", { bg = bg2 })
hl(0, "CmpBorder", { fg = bg3 })

-- Mini statusline
hl(0, "MiniStatuslineModeNormal", { fg = bg0, bg = green, bold = true })
hl(0, "MiniStatuslineModeInsert", { fg = bg0, bg = gold, bold = true })
hl(0, "MiniStatuslineModeVisual", { fg = bg0, bg = sage, bold = true })
hl(0, "MiniStatuslineModeCommand", { fg = bg0, bg = terra, bold = true })
hl(0, "MiniStatuslineModeReplace", { fg = bg0, bg = linen, bold = true })
hl(0, "MiniStatuslineFilename", { fg = fg1, bg = bg2 })
hl(0, "MiniStatuslineFileinfo", { fg = fg2, bg = bg2 })
hl(0, "MiniStatuslineInactive", { fg = fg3, bg = bg1 })

-- Snacks.nvim picker + explorer highlights
-- Must use VimEnter autocmd — snacks overrides these on first launch otherwise
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local hl = vim.api.nvim_set_hl

		-- Picker chrome
		hl(0, "SnacksPickerNormal", { fg = fg1, bg = bg1 })
		hl(0, "SnacksPickerBorder", { fg = bg3, bg = bg1 })
		hl(0, "SnacksPickerTitle", { fg = bg0, bg = green })
		hl(0, "SnacksPickerFooter", { fg = fg3, bg = bg1 })

		-- Input / prompt
		hl(0, "SnacksPickerInput", { fg = fg0, bg = bg2 })
		hl(0, "SnacksPickerInputBorder", { fg = bg3, bg = bg2 })
		hl(0, "SnacksPickerInputTitle", { fg = bg0, bg = sage })
		hl(0, "SnacksPickerPrompt", { fg = green, bg = bg2 })

		-- List
		hl(0, "SnacksPickerList", { fg = fg1, bg = bg0 })
		hl(0, "SnacksPickerListCursorLine", { fg = fg0, bg = bg4 })
		hl(0, "SnacksPickerMatch", { fg = gold, bold = true })

		-- File paths
		hl(0, "SnacksPickerFile", { fg = fg1 })
		hl(0, "SnacksPickerDir", { fg = fg2 })
		hl(0, "SnacksPickerPathHidden", { fg = fg3 })
		hl(0, "SnacksPickerPathIgnored", { fg = bg3 })

		-- Git status in picker
		hl(0, "SnacksPickerGitStatusAdded", { fg = green })
		hl(0, "SnacksPickerGitStatusModified", { fg = gold })
		hl(0, "SnacksPickerGitStatusDeleted", { fg = terra })
		hl(0, "SnacksPickerGitStatusUntracked", { fg = sage })
		hl(0, "SnacksPickerGitStatusIgnored", { fg = bg3 })
		hl(0, "SnacksPickerGitStatusRenamed", { fg = linen })
		hl(0, "SnacksPickerGitStatusCopied", { fg = linen })

		-- Preview pane
		hl(0, "SnacksPickerPreview", { fg = fg1, bg = bg0 })
		hl(0, "SnacksPickerPreviewBorder", { fg = bg3, bg = bg0 })
		hl(0, "SnacksPickerPreviewTitle", { fg = bg0, bg = mist })
		hl(0, "SnacksPickerPreviewLine", { bg = bg2 })

		-- Notifications (snacks.notifier)
		hl(0, "SnacksNotifierBorderInfo", { fg = sage })
		hl(0, "SnacksNotifierBorderWarn", { fg = gold })
		hl(0, "SnacksNotifierBorderError", { fg = terra })
		hl(0, "SnacksNotifierBorderDebug", { fg = fg3 })
		hl(0, "SnacksNotifierIconInfo", { fg = sage })
		hl(0, "SnacksNotifierIconWarn", { fg = gold })
		hl(0, "SnacksNotifierIconError", { fg = terra })
		hl(0, "SnacksNotifierTitleInfo", { fg = sage })
		hl(0, "SnacksNotifierTitleWarn", { fg = gold })
		hl(0, "SnacksNotifierTitleError", { fg = terra })

		-- Dashboard
		hl(0, "SnacksDashboardNormal", { fg = fg1, bg = bg0 })
		hl(0, "SnacksDashboardDesc", { fg = fg2 })
		hl(0, "SnacksDashboardFile", { fg = fg1 })
		hl(0, "SnacksDashboardDir", { fg = fg2 })
		hl(0, "SnacksDashboardHeader", { fg = green, bold = true })
		hl(0, "SnacksDashboardFooter", { fg = fg3, italic = true })
		hl(0, "SnacksDashboardKey", { fg = gold, bold = true })
		hl(0, "SnacksDashboardIcon", { fg = sage })
		hl(0, "SnacksDashboardSpecial", { fg = mist })

		-- Indent guides (snacks.indent)
		--
		hl(0, "SnacksIndent", { fg = bg0 })
		hl(0, "SnacksIndentScope", { fg = bg1 })

		hl(0, "SnacksExplorerNormal", { fg = fg1, bg = bg0 })
		hl(0, "SnacksExplorerWinBar", { bg = bg0 })
		-- Words (snacks.words — highlights current word refs)
		hl(0, "SnacksWordsRef", { bg = bg3 })
		hl(0, "SnacksWordsRefCur", { bg = bg4 })
	end,
})

-- nvim-web-devicons / mini.icons folder override
hl(0, "DevIconDefault", { fg = sage })
hl(0, "MiniIconsDirectory", { fg = sage }) -- mini.icons folders
hl(0, "Directory", { fg = sage }) -- built-in dir highlight
-- mini.icons — override directory/folder colour
hl(0, "MiniIconsAzure", { fg = "#A8B898" }) -- this is the default folder colour
hl(0, "MiniIconsBlue", { fg = "#8FA89C" }) -- mist — used for some file types
hl(0, "MiniIconsCyan", { fg = "#A8B898" }) -- also used on some dirs
hl(0, "MiniIconsGrey", { fg = "#9C9488" }) -- fg2 — muted stone
hl(0, "MiniIconsGreen", { fg = "#7FA688" }) -- keep brand green
hl(0, "MiniIconsYellow", { fg = "#C4A882" }) -- keep gold
hl(0, "MiniIconsOrange", { fg = "#C47A5A" }) -- keep terracotta
hl(0, "MiniIconsRed", { fg = "#C47A5A" }) -- terracotta
hl(0, "MiniIconsPurple", { fg = "#B8A898" }) -- linen — desaturated

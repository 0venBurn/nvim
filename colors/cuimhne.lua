-- Warm dark colorscheme for Neovim
-- Candlelight on aged linen. Not a terminal.

---@class Cuimhne
---@field config CuimhneConfig
---@field palette CuimhnePalette
local Cuimhne = {}

---@class CuimhneItalicConfig
---@field strings boolean
---@field comments boolean
---@field operators boolean
---@field folds boolean
---@field emphasis boolean

---@class CuimhneHighlightDefinition
---@field fg string?
---@field bg string?
---@field sp string?
---@field blend integer?
---@field bold boolean?
---@field standout boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field underdouble boolean?
---@field underdotted boolean?
---@field strikethrough boolean?
---@field italic boolean?
---@field reverse boolean?
---@field nocombine boolean?
---@field link string?

---@class CuimhneConfig
---@field terminal_colors boolean?
---@field transparent_mode boolean?
---@field dim_inactive boolean?
---@field bold boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field strikethrough boolean?
---@field italic CuimhneItalicConfig?
---@field overrides table<string, CuimhneHighlightDefinition>?
---@field palette_overrides table<string, string>?
local default_config = {
	terminal_colors = true,
	transparent_mode = false,
	dim_inactive = false,
	bold = true,
	underline = true,
	undercurl = true,
	strikethrough = true,
	italic = {
		strings = true,
		comments = true,
		operators = false,
		folds = true,
		emphasis = true,
	},
	overrides = {},
	palette_overrides = {},
}

Cuimhne.config = vim.deepcopy(default_config)

---@class CuimhnePalette
Cuimhne.palette = {
	bg0 = "#1A1714",
	bg1 = "#242019",
	bg2 = "#2E2921",
	bg3 = "#332E27",
	bg4 = "#3D3830",
	fg0 = "#F0EBE1",
	fg1 = "#D4CEC6",
	fg2 = "#9C9488",
	fg3 = "#6B6560",
	green = "#7FA688",
	green_d = "#5C7A64",
	sage = "#A8B898",
	terra = "#C47A5A",
	terra_d = "#A05C4A",
	gold = "#C4A882",
	gold_d = "#A8855A",
	linen = "#B8A898",
	mist = "#8FA89C",
}

local function get_colors()
	local colors = vim.deepcopy(Cuimhne.palette)
	for color, hex in pairs(Cuimhne.config.palette_overrides or {}) do
		colors[color] = hex
	end
	return colors
end

local function bg(color)
	return Cuimhne.config.transparent_mode and nil or color
end

local function get_groups()
	local c = get_colors()
	local config = Cuimhne.config

	if config.terminal_colors then
		local term_colors = {
			c.bg0,
			c.terra,
			c.green,
			c.gold,
			c.mist,
			c.linen,
			c.sage,
			c.fg1,
			c.fg3,
			c.terra,
			c.green,
			c.gold,
			c.mist,
			c.linen,
			c.sage,
			c.fg0,
		}
		for i, value in ipairs(term_colors) do
			vim.g["terminal_color_" .. i - 1] = value
		end
	end

	---@type table<string, CuimhneHighlightDefinition>
	local groups = {
		-- Named palette groups
		CuimhneBg0 = { fg = c.bg0 },
		CuimhneBg1 = { fg = c.bg1 },
		CuimhneBg2 = { fg = c.bg2 },
		CuimhneBg3 = { fg = c.bg3 },
		CuimhneBg4 = { fg = c.bg4 },
		CuimhneFg0 = { fg = c.fg0 },
		CuimhneFg1 = { fg = c.fg1 },
		CuimhneFg2 = { fg = c.fg2 },
		CuimhneFg3 = { fg = c.fg3 },
		CuimhneGreen = { fg = c.green },
		CuimhneSage = { fg = c.sage },
		CuimhneTerra = { fg = c.terra },
		CuimhneGold = { fg = c.gold },
		CuimhneLinen = { fg = c.linen },
		CuimhneMist = { fg = c.mist },

		-- Editor
		Normal = { fg = c.fg0, bg = bg(c.bg0) },
		NormalFloat = { fg = c.fg0, bg = bg(c.bg2) },
		NormalNC = config.dim_inactive and { fg = c.fg1, bg = bg(c.bg1) } or { fg = c.fg1, bg = bg(c.bg0) },
		SignColumn = { fg = c.fg2, bg = bg(c.bg0) },
		LineNr = { fg = c.bg3, bg = bg(c.bg0) },
		CursorLineNr = { fg = c.fg2, bg = bg(c.bg0), bold = config.bold },
		CursorLine = { bg = bg(c.bg1) },
		CursorColumn = { link = "CursorLine" },
		ColorColumn = { bg = bg(c.bg1) },
		Folded = { fg = c.fg3, bg = bg(c.bg1), italic = config.italic.folds },
		FoldColumn = { fg = c.bg3, bg = bg(c.bg0) },
		VertSplit = { fg = c.bg3, bg = bg(c.bg0) },
		WinSeparator = { fg = c.bg3, bg = bg(c.bg0) },
		EndOfBuffer = { fg = c.bg2 },
		NonText = { fg = c.bg3 },
		SpecialKey = { fg = c.bg3 },
		Whitespace = { fg = c.bg3 },
		Conceal = { fg = c.fg3 },
		Directory = { fg = c.sage },
		Title = { fg = c.green, bold = config.bold },
		MatchParen = { bg = bg(c.bg3), bold = config.bold },

		-- Selection and search
		Visual = { bg = c.bg4 },
		VisualNOS = { bg = c.bg3 },
		Search = { fg = c.bg0, bg = c.gold },
		IncSearch = { fg = c.bg0, bg = c.terra },
		CurSearch = { fg = c.bg0, bg = c.gold },
		Substitute = { fg = c.bg0, bg = c.terra },
		QuickFixLine = { bg = bg(c.bg2) },

		-- Statusline and tabs
		StatusLine = { fg = c.fg1, bg = bg(c.bg2) },
		StatusLineNC = { fg = c.fg3, bg = bg(c.bg1) },
		WildMenu = { fg = c.bg0, bg = c.green, bold = config.bold },
		TabLine = { fg = c.fg2, bg = bg(c.bg1) },
		TabLineSel = { fg = c.fg0, bg = bg(c.bg3) },
		TabLineFill = { bg = bg(c.bg1) },
		WinBar = { fg = c.fg2, bg = bg(c.bg0) },
		WinBarNC = { fg = c.fg3, bg = bg(c.bg1) },

		-- Floating menus
		Pmenu = { fg = c.fg1, bg = bg(c.bg2) },
		PmenuSel = { fg = c.fg0, bg = c.bg4 },
		PmenuSbar = { bg = bg(c.bg2) },
		PmenuThumb = { bg = c.bg3 },
		FloatBorder = { fg = c.bg3, bg = bg(c.bg2) },
		FloatTitle = { fg = c.sage, bg = bg(c.bg2) },

		-- Messages
		ErrorMsg = { fg = c.terra, bold = config.bold },
		WarningMsg = { fg = c.gold },
		MoreMsg = { fg = c.green },
		ModeMsg = { fg = c.fg2 },
		Question = { fg = c.sage },

		-- Base syntax
		Comment = { fg = c.fg3, italic = config.italic.comments },
		Constant = { fg = c.linen },
		String = { fg = c.gold, italic = config.italic.strings },
		Character = { fg = c.gold },
		Number = { fg = c.gold_d },
		Boolean = { fg = c.terra },
		Float = { fg = c.gold_d },
		Identifier = { fg = c.fg0 },
		Function = { fg = c.mist },
		Statement = { fg = c.green_d, bold = config.bold },
		Conditional = { fg = c.green_d, bold = config.bold },
		Repeat = { fg = c.green_d, bold = config.bold },
		Label = { fg = c.green },
		Operator = { fg = c.sage, italic = config.italic.operators },
		Keyword = { fg = c.green_d, bold = config.bold },
		Exception = { fg = c.terra, bold = config.bold },
		PreProc = { fg = c.linen },
		Include = { fg = c.linen },
		Define = { fg = c.linen },
		Macro = { fg = c.linen },
		PreCondit = { fg = c.linen },
		Type = { fg = c.linen },
		StorageClass = { fg = c.linen },
		Structure = { fg = c.linen },
		Typedef = { fg = c.linen },
		Special = { fg = c.sage },
		SpecialChar = { fg = c.sage },
		Tag = { fg = c.terra },
		Delimiter = { fg = c.fg2 },
		SpecialComment = { fg = c.fg2, italic = config.italic.comments },
		Debug = { fg = c.terra },
		Underlined = { underline = config.underline },
		Ignore = { fg = c.bg3 },
		Error = { fg = c.terra, bold = config.bold },
		Todo = { fg = c.bg0, bg = c.gold, bold = config.bold },

		-- Treesitter
		["@comment"] = { link = "Comment" },
		["@none"] = { fg = "NONE", bg = "NONE" },
		["@variable"] = { fg = c.fg0 },
		["@variable.builtin"] = { fg = c.terra },
		["@variable.parameter"] = { fg = c.fg1 },
		["@variable.member"] = { fg = c.fg0 },
		["@constant"] = { fg = c.linen },
		["@constant.builtin"] = { fg = c.linen, bold = config.bold },
		["@constant.macro"] = { fg = c.linen },
		["@string"] = { fg = c.gold, italic = config.italic.strings },
		["@string.escape"] = { fg = c.sage },
		["@string.regex"] = { fg = c.sage },
		["@string.special"] = { fg = c.sage },
		["@number"] = { fg = c.gold_d },
		["@number.float"] = { fg = c.gold_d },
		["@boolean"] = { fg = c.terra },
		["@float"] = { fg = c.gold_d },
		["@function"] = { fg = c.mist },
		["@function.builtin"] = { fg = c.mist, italic = true },
		["@function.call"] = { fg = c.mist },
		["@function.macro"] = { fg = c.linen },
		["@function.method"] = { fg = c.mist },
		["@function.method.call"] = { fg = c.mist },
		["@method"] = { link = "@function.method" },
		["@method.call"] = { link = "@function.method.call" },
		["@constructor"] = { fg = c.linen },
		["@keyword"] = { fg = c.green_d, bold = config.bold },
		["@keyword.function"] = { fg = c.green_d, bold = config.bold },
		["@keyword.modifier"] = { fg = c.gold_d, italic = true },
		["@keyword.type"] = { fg = c.green, bold = config.bold },
		["@keyword.return"] = { fg = c.terra, bold = config.bold },
		["@keyword.operator"] = { fg = c.sage },
		["@keyword.import"] = { fg = c.linen },
		["@keyword.conditional"] = { fg = c.green_d, bold = config.bold },
		["@keyword.repeat"] = { fg = c.green_d, bold = config.bold },
		["@keyword.exception"] = { fg = c.terra, bold = config.bold },
		["@keyword.directive"] = { link = "PreProc" },
		["@type"] = { fg = c.linen },
		["@type.java"] = { fg = c.linen, bold = config.bold },
		["@type.builtin"] = { fg = c.linen, italic = true },
		["@type.definition"] = { fg = c.linen },
		["@type.qualifier"] = { link = "@keyword.modifier" },
		["@attribute"] = { fg = c.sage },
		["@property"] = { fg = c.fg1 },
		["@operator"] = { fg = c.sage, italic = config.italic.operators },
		["@punctuation"] = { fg = c.fg2 },
		["@punctuation.bracket"] = { fg = c.fg2 },
		["@punctuation.delimiter"] = { fg = c.fg2 },
		["@punctuation.special"] = { fg = c.sage },
		["@tag"] = { fg = c.terra },
		["@tag.attribute"] = { fg = c.sage },
		["@tag.delimiter"] = { fg = c.fg3 },
		["@markup"] = { fg = c.fg1 },
		["@markup.heading"] = { fg = c.green, bold = config.bold },
		["@markup.link"] = { fg = c.mist, underline = config.underline },
		["@markup.link.url"] = { fg = c.sage, underline = config.underline },
		["@markup.raw"] = { fg = c.gold },
		["@markup.strong"] = { bold = config.bold },
		["@markup.italic"] = { italic = config.italic.emphasis },
		["@markup.list"] = { fg = c.terra },
		["@markup.list.checked"] = { fg = c.green },
		["@markup.list.unchecked"] = { fg = c.fg3 },
		["@diff.plus"] = { link = "DiffAdd" },
		["@diff.minus"] = { link = "DiffDelete" },
		["@diff.delta"] = { link = "DiffChange" },
		["@module"] = { fg = c.fg1 },
		["@namespace"] = { link = "@module" },

		-- LSP semantic tokens
		["@lsp.type.class"] = { link = "@type" },
		["@lsp.type.class.java"] = { link = "@type.java" },
		["@lsp.type.interface"] = { link = "@type" },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.type"] = { link = "@type" },
		["@lsp.type.typeParameter"] = { link = "@type.definition" },
		["@lsp.type.method"] = { link = "@function.method" },
		["@lsp.type.function"] = { link = "@function" },
		["@lsp.type.property"] = { link = "@property" },
		["@lsp.type.variable"] = { link = "@variable" },
		["@lsp.type.parameter"] = { link = "@variable.parameter" },
		["@lsp.type.enumMember"] = { link = "@constant" },
		["@lsp.type.modifier"] = { link = "@keyword.modifier" },
		["@lsp.type.modifier.java"] = { link = "@keyword.modifier" },
		["@lsp.mod.public.java"] = { link = "@keyword.modifier" },
		["@lsp.mod.private.java"] = { link = "@keyword.modifier" },
		["@lsp.mod.protected.java"] = { link = "@keyword.modifier" },
		["@lsp.typemod.class.public.java"] = { link = "@type.java" },

		-- Diagnostics and LSP UI
		DiagnosticError = { fg = c.terra },
		DiagnosticWarn = { fg = c.gold },
		DiagnosticInfo = { fg = c.sage },
		DiagnosticHint = { fg = c.mist },
		DiagnosticOk = { fg = c.green },
		DiagnosticSignError = { fg = c.terra, bg = bg(c.bg0) },
		DiagnosticSignWarn = { fg = c.gold, bg = bg(c.bg0) },
		DiagnosticSignInfo = { fg = c.sage, bg = bg(c.bg0) },
		DiagnosticSignHint = { fg = c.mist, bg = bg(c.bg0) },
		DiagnosticUnderlineError = { undercurl = config.undercurl, sp = c.terra },
		DiagnosticUnderlineWarn = { undercurl = config.undercurl, sp = c.gold },
		DiagnosticUnderlineInfo = { undercurl = config.undercurl, sp = c.sage },
		DiagnosticUnderlineHint = { undercurl = config.undercurl, sp = c.mist },
		DiagnosticVirtualTextError = { fg = c.terra, bg = bg(c.bg1) },
		DiagnosticVirtualTextWarn = { fg = c.gold, bg = bg(c.bg1) },
		DiagnosticVirtualTextInfo = { fg = c.sage, bg = bg(c.bg1) },
		DiagnosticVirtualTextHint = { fg = c.mist, bg = bg(c.bg1) },
		LspReferenceText = { bg = c.bg3 },
		LspReferenceRead = { bg = c.bg3 },
		LspReferenceWrite = { bg = c.bg4 },
		LspInlayHint = { fg = c.fg3, bg = bg(c.bg1), italic = true },
		LspCodeLens = { fg = c.fg3 },
		LspSignatureActiveParameter = { bg = c.bg3, bold = config.bold },

		-- Git and diffs
		DiffAdd = { fg = c.green, bg = bg(c.bg1) },
		DiffChange = { fg = c.gold, bg = bg(c.bg1) },
		DiffDelete = { fg = c.terra, bg = bg(c.bg1) },
		DiffText = { fg = c.bg0, bg = c.gold },
		GitSignsAdd = { fg = c.green },
		GitSignsChange = { fg = c.gold },
		GitSignsDelete = { fg = c.terra },
		DiffviewStatusModified = { fg = c.gold, bold = config.bold },
		DiffviewFilePanelInsertions = { fg = c.green, bold = config.bold },
		DiffviewFilePanelDeletions = { fg = c.terra, bold = config.bold },

		-- Markdown
		RenderMarkdownCode = { bg = bg(c.bg0) },
		RenderMarkdownUnchecked = { fg = c.fg3 },
		RenderMarkdownChecked = { fg = c.green },

		-- Which-key
		WhichKey = { fg = c.sage },
		WhichKeyGroup = { fg = c.green },
		WhichKeyDesc = { fg = c.fg1 },
		WhichKeyBorder = { fg = c.bg3 },
		WhichKeyFloat = { bg = bg(c.bg2) },
		WhichKeyTitle = { link = "FloatTitle" },

		-- nvim-cmp
		CmpItemAbbr = { fg = c.fg1 },
		CmpItemAbbrDeprecated = { fg = c.fg3, strikethrough = config.strikethrough },
		CmpItemAbbrMatch = { fg = c.gold, bold = config.bold },
		CmpItemAbbrMatchFuzzy = { fg = c.gold },
		CmpItemKind = { fg = c.sage },
		CmpItemKindText = { fg = c.gold },
		CmpItemKindVariable = { fg = c.fg1 },
		CmpItemKindMethod = { fg = c.mist },
		CmpItemKindFunction = { fg = c.mist },
		CmpItemKindConstructor = { fg = c.linen },
		CmpItemKindClass = { fg = c.linen },
		CmpItemKindInterface = { fg = c.linen },
		CmpItemKindModule = { fg = c.sage },
		CmpItemKindProperty = { fg = c.fg1 },
		CmpItemKindKeyword = { fg = c.green_d, bold = config.bold },
		CmpItemKindSnippet = { fg = c.green },
		CmpItemKindFile = { fg = c.mist },
		CmpItemMenu = { fg = c.fg3 },
		CmpNormal = { bg = bg(c.bg2) },
		CmpBorder = { fg = c.bg3 },

		-- Mini
		MiniStatuslineModeNormal = { fg = c.bg0, bg = c.green, bold = config.bold },
		MiniStatuslineModeInsert = { fg = c.bg0, bg = c.gold, bold = config.bold },
		MiniStatuslineModeVisual = { fg = c.bg0, bg = c.sage, bold = config.bold },
		MiniStatuslineModeCommand = { fg = c.bg0, bg = c.terra, bold = config.bold },
		MiniStatuslineModeReplace = { fg = c.bg0, bg = c.linen, bold = config.bold },
		MiniStatuslineFilename = { fg = c.fg1, bg = bg(c.bg2) },
		MiniStatuslineFileinfo = { fg = c.fg2, bg = bg(c.bg2) },
		MiniStatuslineInactive = { fg = c.fg3, bg = bg(c.bg1) },
		MiniIconsDirectory = { fg = c.sage },
		MiniIconsAzure = { fg = c.sage },
		MiniIconsBlue = { fg = c.mist },
		MiniIconsCyan = { fg = c.sage },
		MiniIconsGrey = { fg = c.fg2 },
		MiniIconsGreen = { fg = c.green },
		MiniIconsYellow = { fg = c.gold },
		MiniIconsOrange = { fg = c.terra },
		MiniIconsRed = { fg = c.terra },
		MiniIconsPurple = { fg = c.linen },

		-- Snacks picker/explorer/notifier/dashboard/indent/words
		SnacksPickerNormal = { fg = c.fg1, bg = bg(c.bg1) },
		SnacksPickerBorder = { fg = c.bg3, bg = bg(c.bg1) },
		SnacksPickerTitle = { fg = c.bg0, bg = c.green },
		SnacksPickerFooter = { fg = c.fg3, bg = bg(c.bg1) },
		SnacksPickerInput = { fg = c.fg0, bg = bg(c.bg2) },
		SnacksPickerInputBorder = { fg = c.bg3, bg = bg(c.bg2) },
		SnacksPickerInputTitle = { fg = c.bg0, bg = c.sage },
		SnacksPickerPrompt = { fg = c.green, bg = bg(c.bg2) },
		SnacksPickerList = { fg = c.fg1, bg = bg(c.bg0) },
		SnacksPickerListCursorLine = { fg = c.fg0, bg = c.bg4 },
		SnacksPickerMatch = { fg = c.gold, bold = config.bold },
		SnacksPickerFile = { fg = c.fg1 },
		SnacksPickerDir = { fg = c.fg2 },
		SnacksPickerPathHidden = { fg = c.fg3 },
		SnacksPickerPathIgnored = { fg = c.bg3 },
		SnacksPickerGitStatusAdded = { fg = c.green },
		SnacksPickerGitStatusModified = { fg = c.gold },
		SnacksPickerGitStatusDeleted = { fg = c.terra },
		SnacksPickerGitStatusUntracked = { fg = c.sage },
		SnacksPickerGitStatusIgnored = { fg = c.bg3 },
		SnacksPickerGitStatusRenamed = { fg = c.linen },
		SnacksPickerGitStatusCopied = { fg = c.linen },
		SnacksPickerPreview = { fg = c.fg1, bg = bg(c.bg0) },
		SnacksPickerPreviewBorder = { fg = c.bg3, bg = bg(c.bg0) },
		SnacksPickerPreviewTitle = { fg = c.bg0, bg = c.mist },
		SnacksPickerPreviewLine = { bg = bg(c.bg2) },
		SnacksNotifierBorderInfo = { fg = c.sage },
		SnacksNotifierBorderWarn = { fg = c.gold },
		SnacksNotifierBorderError = { fg = c.terra },
		SnacksNotifierBorderDebug = { fg = c.fg3 },
		SnacksNotifierIconInfo = { fg = c.sage },
		SnacksNotifierIconWarn = { fg = c.gold },
		SnacksNotifierIconError = { fg = c.terra },
		SnacksNotifierTitleInfo = { fg = c.sage },
		SnacksNotifierTitleWarn = { fg = c.gold },
		SnacksNotifierTitleError = { fg = c.terra },
		SnacksDashboardNormal = { fg = c.fg1, bg = bg(c.bg0) },
		SnacksDashboardDesc = { fg = c.fg2 },
		SnacksDashboardFile = { fg = c.fg1 },
		SnacksDashboardDir = { fg = c.fg2 },
		SnacksDashboardHeader = { fg = c.green, bold = config.bold },
		SnacksDashboardFooter = { fg = c.fg3, italic = true },
		SnacksDashboardKey = { fg = c.gold, bold = config.bold },
		SnacksDashboardIcon = { fg = c.sage },
		SnacksDashboardSpecial = { fg = c.mist },
		SnacksIndent = { fg = c.bg0 },
		SnacksIndentScope = { fg = c.bg1 },
		SnacksExplorerNormal = { fg = c.fg1, bg = bg(c.bg0) },
		SnacksExplorerWinBar = { bg = bg(c.bg0) },
		SnacksWordsRef = { bg = c.bg3 },
		SnacksWordsRefCur = { bg = c.bg4 },

		-- DAP
		DapBreakpointSymbol = { fg = c.terra, bg = bg(c.bg1) },
		DapStoppedSymbol = { fg = c.green, bg = bg(c.bg1) },
		DapUIBreakpointsCurrentLine = { fg = c.gold },
		DapUIBreakpointsDisabledLine = { fg = c.fg3 },
		DapUIBreakpointsInfo = { fg = c.sage },
		DapUIBreakpointsLine = { fg = c.gold },
		DapUIBreakpointsPath = { fg = c.mist },
		DapUICurrentFrameName = { fg = c.linen },
		DapUIDecoration = { fg = c.linen },
		DapUIFloatBorder = { fg = c.sage },
		DapUILineNumber = { fg = c.gold },
		DapUIModifiedValue = { fg = c.terra },
		DapUIScope = { fg = c.mist },
		DapUISource = { fg = c.fg1 },
		DapUIThread = { fg = c.mist },
		DapUIType = { fg = c.linen },
		DapUIUnavailable = { fg = c.fg3 },
		DapUIWatchesEmpty = { fg = c.fg3 },
		DapUIWatchesError = { fg = c.terra },
		DapUIWatchesValue = { fg = c.gold },
		DapUIWinSelect = { fg = c.gold, bold = config.bold },

		-- Devicons
		DevIconDefault = { fg = c.sage },
	}

	for group, hl in pairs(config.overrides or {}) do
		if groups[group] then
			groups[group].link = nil
		end
		groups[group] = vim.tbl_extend("force", groups[group] or {}, hl)
	end

	return groups
end

---@param config CuimhneConfig?
function Cuimhne.setup(config)
	Cuimhne.config = vim.deepcopy(default_config)
	Cuimhne.config = vim.tbl_deep_extend("force", Cuimhne.config, config or {})
end

function Cuimhne.load()
	if vim.g.colors_name then
		vim.cmd("highlight clear")
	end

	vim.g.colors_name = "cuimhne"
	vim.o.termguicolors = true

	for group, settings in pairs(get_groups()) do
		vim.api.nvim_set_hl(0, group, settings)
	end

	-- Snacks can override some groups during startup; re-apply after UI/plugin init.
	vim.api.nvim_create_autocmd("VimEnter", {
		group = vim.api.nvim_create_augroup("cuimhne-refresh-plugin-highlights", { clear = true }),
		callback = function()
			for group, settings in pairs(get_groups()) do
				if group:match("^Snacks") then
					vim.api.nvim_set_hl(0, group, settings)
				end
			end
		end,
	})
end

Cuimhne.load()

return Cuimhne

vim.g.mapleader = " "

local keymap = vim.keymap

-- Helper function for setting keymaps
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- General keymaps
map("i", "jk", "<ESC>")
map("n", "<leader>wq", ":wq<CR>")
map("n", "<leader>qq", ":q!<CR>")
map("n", "<leader>ww", ":w<CR>")
map("n", "gx", ":!open <c-r><c-a><CR>")

-- Window management
map("n", "<leader>sv", "<C-w>v")
map("n", "<leader>sh", "<C-w>s")
map("n", "<leader>se", "<C-w>=")
map("n", "<leader>sx", ":close<CR>")
map("n", "<leader>sj", "<C-w>-")
map("n", "<leader>sk", "<C-w>+")
map("n", "<leader>sl", "<C-w>>5")
map("n", "<leader>sh", "<C-w><5")

-- Tab management
map("n", "<leader>to", ":tabnew<CR>")
map("n", "<leader>tx", ":tabclose<CR>")
map("n", "<leader>tn", ":tabn<CR>")
map("n", "<leader>tp", ":tabp<CR>")

-- Tmux navigation
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>")

-- Diff keymaps
map("n", "<leader>cc", ":diffput<CR>")
map("n", "<leader>cj", ":diffget 1<CR>")
map("n", "<leader>ck", ":diffget 3<CR>")
map("n", "<leader>cn", "]c")
map("n", "<leader>cp", "[c")

-- Quickfix keymaps
map("n", "<leader>qo", ":copen<CR>")
map("n", "<leader>qf", ":cfirst<CR>")
map("n", "<leader>qn", ":cnext<CR>")
map("n", "<leader>qp", ":cprev<CR>")
map("n", "<leader>ql", ":clast<CR>")
map("n", "<leader>qc", ":cclose<CR>")

-- Nvim-tree
map("n", "<leader>ee", ":NvimTreeToggle<CR>")
map("n", "<leader>er", ":NvimTreeFocus<CR>")
map("n", "<leader>ef", ":NvimTreeFindFile<CR>")

-- Telescope
local telescope = require("telescope.builtin")
map("n", "<leader>ff", function()
	telescope.find_files()
end)
map("n", "<leader>fg", function()
	telescope.live_grep()
end)
map("n", "<leader>fb", function()
	telescope.buffers()
end)
map("n", "<leader>fh", function()
	telescope.help_tags()
end)
map("n", "<leader>fs", function()
	telescope.current_buffer_fuzzy_find()
end)
map("n", "<leader>fo", function()
	telescope.lsp_document_symbols()
end)
map("n", "<leader>fi", function()
	telescope.lsp_incoming_calls()
end)
map("n", "<leader>fm", function()
	telescope.treesitter({ default_text = ":method:" })
end)

-- LSP
map("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
map("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
map("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
map("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")

-- Debugging
local dap = require("dap")
local dapui = require("dapui")

map("n", "<leader>bb", function()
	dap.toggle_breakpoint()
end)
map("n", "<leader>bc", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
map("n", "<leader>bl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
map("n", "<leader>br", function()
	dap.clear_breakpoints()
end)
map("n", "<leader>ba", function()
	telescope.dap.list_breakpoints()
end)
map("n", "<leader>dc", function()
	dap.continue()
end)
map("n", "<leader>dj", function()
	dap.step_over()
end)
map("n", "<leader>dk", function()
	dap.step_into()
end)
map("n", "<leader>do", function()
	dap.step_out()
end)
map("n", "<leader>dd", function()
	dap.disconnect()
	dapui.close()
end)
map("n", "<leader>dt", function()
	dap.terminate()
	dapui.close()
end)
map("n", "<leader>dr", function()
	dap.repl.toggle()
end)
map("n", "<leader>dl", function()
	dap.run_last()
end)
map("n", "<leader>di", function()
	require("dap.ui.widgets").hover()
end)
map("n", "<leader>d?", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)
map("n", "<leader>df", function()
	telescope.dap.frames()
end)
map("n", "<leader>dh", function()
	telescope.dap.commands()
end)
map("n", "<leader>de", function()
	telescope.diagnostics({ default_text = ":E:" })
end)

-- Filetype-specific keymaps
map("n", "<leader>go", function()
	if vim.bo.filetype == "java" then
		require("jdtls").organize_imports()
	end
end)

map("n", "<leader>gu", function()
	if vim.bo.filetype == "java" then
		require("jdtls").update_projects_config()
	end
end)

map("n", "<leader>tc", function()
	if vim.bo.filetype == "java" then
		require("jdtls").test_class()
	end
end)

map("n", "<leader>tm", function()
	if vim.bo.filetype == "java" then
		require("jdtls").test_nearest_method()
	end
end)

-- Harpoon
local harpoon = require("harpoon")
for i = 1, 9 do
	map("n", "<leader>n" .. tostring(i), function()
		harpoon.ui.nav_file(i)
	end)
end
map("n", "<leader>na", function()
	harpoon.mark.add_file()
end)
map("n", "<leader>nh", function()
	harpoon.ui.toggle_quick_menu()
end)

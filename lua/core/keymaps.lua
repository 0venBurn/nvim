vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- General
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "gx", ":!open <c-r><c-a><CR>", { desc = "Open URL under cursor" })
keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })
keymap.set("n", "<leader>qq", ":q!<CR>", { desc = "Quit without saving" })
keymap.set("n", "<leader>ww", ":w<CR>", { desc = "Save file" })

-- Run files
keymap.set("n", "<leader>xf", "<cmd>RunFile<CR>", { desc = "Run current file" })
keymap.set("n", "<leader>xp", "<cmd>RunPackage<CR>", { desc = "Run current package" })
keymap.set("n", "<leader>xP", "<cmd>RunProject<CR>", { desc = "Run current project" })
keymap.set("n", "<leader>xt", "<cmd>RunTests<CR>", { desc = "Run tests" })
keymap.set("n", "<leader>xl", "<cmd>RunLast<CR>", { desc = "Run last command" })

-- Move lines
keymap.set("n", "K", ":move .-2<CR>==", vim.tbl_extend("force", opts, { desc = "Move line up" }))
keymap.set("v", "K", ":move '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))
keymap.set("n", "J", ":move .+1<CR>==", vim.tbl_extend("force", opts, { desc = "Move line down" }))
keymap.set("v", "J", ":move '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))

-- Splits / windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close split" })
keymap.set("n", "<leader>sj", "<C-w>-", { desc = "Decrease split height" })
keymap.set("n", "<leader>sk", "<C-w>+", { desc = "Increase split height" })
keymap.set("n", "<leader>sl", "<C-w>>5", { desc = "Increase split width" })
keymap.set("n", "<leader>sh", "<C-w><5", { desc = "Decrease split width" })
keymap.set("n", "<leader>sm", ":only<CR>", { desc = "Maximize current split" })

-- Tabs
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Previous tab" })

-- Buffers
keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bub", ":b#<CR>", { desc = "Toggle previous buffer" })
keymap.set("n", "<leader>bb", ":bdelete<CR>", { desc = "Delete buffer" })
keymap.set("n", "<leader>bl", ":buffers<CR>", { desc = "List buffers" })

-- Quickfix
keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix list" })
keymap.set("n", "<leader>qf", ":cfirst<CR>", { desc = "First quickfix item" })
keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Next quickfix item" })
keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "Previous quickfix item" })
keymap.set("n", "<leader>ql", ":clast<CR>", { desc = "Last quickfix item" })
keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix list" })

-- LSP
keymap.set("n", "<leader>lt", "<cmd>LspToggle<CR>", { desc = "Toggle LSP" })
keymap.set("n", "<leader>lo", "<cmd>LspOn<CR>", { desc = "Turn LSP on" })
keymap.set("n", "<leader>lO", "<cmd>LspOff<CR>", { desc = "Turn LSP off" })
keymap.set("n", "<leader>ls", "<cmd>LspStatus<CR>", { desc = "Show LSP status" })
keymap.set("n", "<leader>gg", function()
	local source_buf = vim.api.nvim_get_current_buf()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local ok, hover_buf = pcall(vim.api.nvim_win_get_var, win, "textDocument/hover")
		if ok and hover_buf == source_buf and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_set_current_win(win)
			vim.cmd("stopinsert")
			return
		end
	end
	vim.lsp.buf.hover()
end, { desc = "LSP hover" })
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })
keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help" })
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format buffer" })
keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format selection" })
keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code action" })
keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Line diagnostics" })
keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })
keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { desc = "Document symbols" })
keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", { desc = "LSP completion" })

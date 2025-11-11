vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>")                 -- exit insert mode with jk
keymap.set("n", "<leader>wq", ":wq<CR>")       -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>")       -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>")        -- save
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor

keymap.set("n", "<leader><leader>x", function()
  local file = vim.fn.expand('%:p')
  local output = vim.fn.system('python3 ' .. file)

  -- Show output in a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded'
  })
end, { desc = "Execute the current file" })

-- Move current line or selected lines up
keymap.set("n", "K", ":move .-2<CR>==", { noremap = true, silent = true })
keymap.set("v", "K", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

keymap.set("n", "<leader>pb", ":bp<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>nb", ":bp<CR>", { noremap = true, silent = true })

-- Move current line or selected lines down
keymap.set("n", "J", ":move .+1<CR>==", { noremap = true, silent = true })
keymap.set("v", "J", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v")     -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")     -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=")     -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-")     -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+")     -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5")    -- make split windows width bigger
keymap.set("n", "<leader>sh", "<C-w><5")    -- make split windows width smaller

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<leader>tn", ":tabn<CR>")     -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>")     -- previous tab
keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>")

-- Buffer management
keymap.set("n", "<leader>bn", ":bnext<CR>")     -- Next buffer
keymap.set("n", "<leader>bp", ":bprevious<CR>") -- Previous buffer
keymap.set("n", "<leader>bb", ":b#<CR>")        -- Toggle between current and last buffer
keymap.set("n", "<leader>bd", ":bdelete<CR>")   -- Delete current buffer
keymap.set("n", "<leader>bl", ":buffers<CR>")   -- List all buffers

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>")  -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>")  -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>")  -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>")  -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle maximize tab

Snacks = require("snacks")

-- Explorer keymaps (replacing NvimTree)
keymap.set("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Toggle File Explorer" })

keymap.set("n", "<leader>ee", function()
  Snacks.explorer()
end, { desc = "Toggle File Explorer" })

keymap.set("n", "<leader>er", function()
  Snacks.explorer({ focus = true })
end, { desc = "Focus File Explorer" })

keymap.set("n", "<leader>ef", function()
  Snacks.explorer({ focus = true, follow_file = true })
end, { desc = "Find File in Explorer" })

-- Replace telescope keymaps with snacks.picker
keymap.set("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

keymap.set("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Live Grep" })

keymap.set("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Find Buffers" })

keymap.set("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help Tags" })

keymap.set("n", "<leader>fs", function()
  Snacks.picker.lines()
end, { desc = "Current Buffer Fuzzy Find" })

keymap.set("n", "<leader>fo", function()
  Snacks.picker.lsp_symbols()
end, { desc = "LSP Document Symbols" })

keymap.set("n", "<leader>fi", function()
  Snacks.picker.lsp_references()
end, { desc = "LSP Incoming Calls/References" })

keymap.set("n", "<leader>fm", function()
  Snacks.picker.lsp_symbols({ symbols = { "method", "function" } })
end, { desc = "Find Methods/Functions" })

-- Additional useful snacks.picker keymaps you might want
keymap.set("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "Recent Files" })

keymap.set("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Config Files" })

keymap.set("n", "<leader>fd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })

keymap.set("n", "<leader>fw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep Word Under Cursor" })

keymap.set("n", "<leader>gF", function()
  Snacks.picker.git_files()
end, { desc = "Git Files" })

keymap.set("n", "<leader>gc", function()
  Snacks.picker.git_status()
end, { desc = "Git Status" })

-- Smart picker (automatically chooses best source)
keymap.set("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart Find" })

-- Quick access to picker with custom options
keymap.set("n", "<leader>fF", function()
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find All Files (including hidden)" })

keymap.set("n", "<leader>fG", function()
  Snacks.picker.grep({ hidden = true, ignored = true })
end, { desc = "Live Grep (including hidden)" })

-- Git
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame
keymap.set("n", "<leader>git", ":LazyGit<CR>")

-- Harpoon
keymap.set("n", "<leader>na", require("harpoon.mark").add_file)
keymap.set("n", "<leader>nh", require("harpoon.ui").toggle_quick_menu)
keymap.set("n", "<leader>n1", function()
  require("harpoon.ui").nav_file(1)
end)

keymap.set("n", "<leader>n2", function()
  require("harpoon.ui").nav_file(2)
end)

keymap.set("n", "<leader>n3", function()
  require("harpoon.ui").nav_file(3)
end)

keymap.set("n", "<leader>n4", function()
  require("harpoon.ui").nav_file(4)
end)

keymap.set("n", "<leader>n5", function()
  require("harpoon.ui").nav_file(5)
end)

-- Vim REST Console
keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- LSP
keymap.set("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>")
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>")
-- Filetype-specific keymaps (these can be done in the ftplugin directory instead if you prefer)
keymap.set("n", "<leader>go", function()
  if vim.bo.filetype == "java" then
    require("jdtls").organize_imports()
  end
end)

keymap.set("n", "<leader>gu", function()
  if vim.bo.filetype == "java" then
    require("jdtls").update_projects_config()
  end
end)

keymap.set("n", "<leader>tc", function()
  if vim.bo.filetype == "java" then
    require("jdtls").test_class()
  end
end)

keymap.set("n", "<leader>tm", function()
  if vim.bo.filetype == "java" then
    require("jdtls").test_nearest_method()
  end
end)

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>")

keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>")
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
keymap.set("n", "<leader>dd", function()
  require("dap").disconnect()
  require("dapui").close()
end)
keymap.set("n", "<leader>dt", function()
  require("dap").terminate()
  require("dapui").close()
end)
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", "<leader>di", function()
  require("dap.ui.widgets").hover()
end)
keymap.set("n", "<leader>d?", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)
keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<cr>")
keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<cr>")
keymap.set("n", "<leader>de", function()
  require("telescope.builtin").diagnostics({ default_text = ":E:" })
end)

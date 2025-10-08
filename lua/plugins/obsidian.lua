return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "main",
        path = "~/vaults/",
      },
      {
        name = "workspaces",
        path = "~/vaults/",
      },
    }, -- Removed detect_cwd from inside workspaces
    note_id_func = function(title)
      return title
    end,
    note_frontmatter_func = function(note)
      return nil
    end,
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "current_dir",
    wiki_link_func = function(opts)
      if opts.id == nil then
        return string.format("[[%s]]", opts.label)
      elseif opts.label ~= opts.id then
        return string.format("[[%s|%s]]", opts.id, opts.label)
      else
        return string.format("[[%s]]", opts.id)
      end
    end,
    mappings = {
      ["<leader>on"] = {
        action = function()
          local title = vim.fn.input("Enter note title: ")
          local path = vim.fs.join(vim.fn.expand("~/.obsidian/notebook/"), title .. ".md")

          if vim.fn.filereadable(path) == 1 then
            print("Note already exists.")
          else
            require("obsidian").new_note({ title = title })
          end
        end,
        opts = { noremap = true, silent = true, buffer = true },
      },
    },

    ui = {
      enable = true,          -- set to false to disable all additional syntax features
      update_debounce = 200,  -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    -- see below for full list of options 👇
  },
}

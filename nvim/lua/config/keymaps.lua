-- ==================================================
-- 1~ General settings
-- ==================================================

-- Leader
vim.g.mapleader = '.'

-- No loop
local opts = { noremap = true, silent = true, nowait = true }

-- ==================================================
-- 2~ Keymaps
-- ==================================================

-- Movement
vim.keymap.set({'n', 'v', 'i'}, '<C-w>', '<Up>', opts)    -- up
vim.keymap.set({'n', 'v', 'i'}, '<C-s>', '<Down>', opts)  -- down
vim.keymap.set({'n', 'v', 'i'}, '<C-a>', '<Left>', opts)  -- left
vim.keymap.set({'n', 'v', 'i'}, '<C-d>', '<Right>', opts) -- right

-- General
vim.keymap.set({'n', 'v', 'i'}, '<C-z>', ':w<CR>', opts)  -- save
vim.keymap.set({'n', 'v', 'i'}, '<C-x>', ':wq<CR>', opts) -- save & quit
vim.keymap.set({'n', 'v'}, '<C-e>', 'ggVG', opts)         -- select all

-- Copy Paste
vim.keymap.set('v', '<C-c>', '"+y', opts)                 -- copy selection
vim.keymap.set('n', '<C-c>', '"+yy', opts)                -- copy line

-- ==================================================
-- 3~ Telescope
-- ==================================================

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Active telescope normal mode' })
vim.keymap.set("n", "<leader>c", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand("~/.config"),
    hidden = true,
  })
end, { desc = "Open .config in Telescope" })

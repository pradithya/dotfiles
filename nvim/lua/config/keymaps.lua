-- ============================================
-- Key mappings (mirrors ~/.vimrc, plus extras)
-- ============================================
-- Plugin-specific keymaps live next to their plugin spec under lua/plugins/.

local map = vim.keymap.set

-- Clear search highlights
map("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlight", silent = true })

-- Quick save and quit
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling / searching
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Better paste over selection (don't yank replaced text)
map("v", "p", '"_dP')

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
-- <leader>bd is defined by mini.bufremove (see lua/plugins/editor.lua) so that
-- deleting a buffer preserves the Neo-tree split layout.

-- UI toggles
map("n", "<leader>tw", function() vim.opt.wrap = not vim.o.wrap end, { desc = "Toggle word wrap" })

-- Terminal splits
map("n", "<leader>ts", "<cmd>split | term<cr>", { desc = "Terminal (horizontal split)" })
map("n", "<leader>tv", "<cmd>vsplit | term<cr>", { desc = "Terminal (vertical split)" })

-- Diagnostics (LSP)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

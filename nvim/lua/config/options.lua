-- ============================================
-- Vim options (mirrors ~/.vimrc, in Lua)
-- ============================================

local opt = vim.opt

-- General
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.history = 1000
opt.undolevels = 1000
opt.undofile = true                          -- persistent undo

-- UI / Display
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmatch = true
opt.showcmd = true
opt.wildmenu = true
opt.laststatus = 3                           -- global statusline
opt.ruler = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true

-- Indentation
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Search
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Editing
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"                -- system clipboard
opt.wrap = false
opt.mouse = "a"

-- Performance
opt.lazyredraw = false                       -- disabled: conflicts with noice/cmdline plugins
opt.ttyfast = true
opt.updatetime = 250
opt.timeoutlen = 400

-- Files
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12

-- Leader key (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable some built-in plugins we don't need
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

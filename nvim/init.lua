-- ============================================
-- Neovim entry point
-- ============================================
-- Loads core options/keymaps and bootstraps lazy.nvim, which then imports
-- every plugin spec file under lua/plugins/.

require("config.options")
require("config.keymaps")
require("config.lazy")

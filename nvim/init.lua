-- [[
--                          Neovim Configuration
--                                                         Yucheng Shi
--                                                         yuchengs.euca [at] gmail.com
--      Note:
--      1. You still need to install language servers (use :LspInstall)
--      2. You still need to install treesitter parsers (use :TSInstall)
--      3. Upon first time setup, run :PackerInstall + :PackerSync to install
--         and update all plugins and configuration
--      4. Everytime configuration is changed, run :PackerCompile / :PackerSync
--         for the configuration to take effect
-- ]]

-- Map leader key before setup
-- why? see :help mapleader
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load options
require('options')

-- Load Plugins
require('plugins')

-- Load Plugin settings
require('plugin-settings')

-- Load Lsp settings
require('lsp-settings')

-- Load treesitter settings
require('treesitter-settings')

-- Load mappings
require('mappings')

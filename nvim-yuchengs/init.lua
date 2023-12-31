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

-- TODO(yuchengs): check minimum required version instead
-- check if we have the latest stable version of nvim
local api = vim.api
local version = vim.version

-- check if we have the latest stable version of nvim
local expected_ver = "0.9.1"
local ev = version.parse(expected_ver)
local actual_ver = version()

if version.cmp(ev, actual_ver) ~= 0 then
  local _ver = string.format("%s.%s.%s", actual_ver.major, actual_ver.minor, actual_ver.patch)
  local msg = string.format("Unsupported nvim version: expect %s, but got %s instead!", expected_ver, _ver)
  api.nvim_err_writeln(msg)
  return
end

-- Map leader key before we do anything. See :help mapleader for why.
vim.api.nvim_set_keymap('', ',', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Load globals
require('globals')

-- Load options
require('options')

-- Load plugins
require('plugins')

-- Load mappings
require('mappings')
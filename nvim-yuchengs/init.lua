-- [[
--                          Neovim Configuration
--                                                         Yucheng Shi
--                                                         yuchengs.euca [at] gmail.com
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

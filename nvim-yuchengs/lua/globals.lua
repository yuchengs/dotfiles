local utils = require('utils')

------------------------------------------------------------------------
--                          custom variables                          --
------------------------------------------------------------------------
vim.g.is_linux = (utils.has("unix") and (not utils.has("macunix"))) and true or false
vim.g.is_mac  = utils.has("macunix") and true or false

------------------------------------------------------------------------
--                         builtin variables                          --
------------------------------------------------------------------------
if utils.executable('python3') then
    vim.g.python3_host_prog = vim.fn.exepath("python3")
else
  api.nvim_err_writeln("Python3 executable not found! You must install Python3 and set its PATH correctly!")
  return
end

-- Do not load builtin matchit.vim and matchparen.vim since we use vim-matchup
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
-- Do no load netrw, see https://github.com/bling/dotvim/issues/4
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_liststyle = 3

-- Scrolloff
vim.g.scrolloff = 5
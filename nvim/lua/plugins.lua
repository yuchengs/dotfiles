---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Load Packages/Plugins
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Make sure packer is installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
vim.api.nvim_exec(
  [[
    augroup Packer
      autocmd!
      autocmd BufWritePost init.lua PackerCompile
    augroup end
  ]],
  false
)
-- Plugins
local use = require('packer').use
return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer itself
  use 'folke/tokyonight.nvim' -- Tokyonight colortheme
  use 'simeji/winresizer' -- resize windows
  use 'itchyny/lightline.vim' -- Fancier statusline
  -- vim things picker, the mighty telescope!
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Ad git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'lukas-reineke/indent-blankline.nvim' -- colorful indent
  use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
  use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
  -------------------------------------------------------------------------------------
  -- tpope collections
  use 'tpope/vim-unimpaired' -- bufferlist, etc
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
  use 'tpope/vim-surround' -- Surround the selection with a pair of marks
  use 'tpope/vim-obsession' -- Autoload session
  -------------------------------------------------------------------------------------
  -- neovim lsp and related
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'kabouzeid/nvim-lspinstall' -- install lsp vis LspInstall
  use 'hrsh7th/nvim-compe'
  use 'windwp/nvim-autopairs' -- auto pairs, woohoo!
  -------------------------------------------------------------------------------------
  -- neovim treesitter
  use 'nvim-treesitter/nvim-treesitter' -- treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'romgrk/nvim-treesitter-context'
end)

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Load Packages/Plugins
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Plugins are managed by lazy.nvim

local utils = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- Basic Plugins
  -- Tokyonight colortheme
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  -- Show hints on keybidings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key-config")
    end,
  },
  -- Highlights, navigates and operates on matching text
  -- It extends % offered by matchit and matchparen
  {
    "andymass/vim-matchup",
    lazy = false, -- Author recommends against lazy loading it on events
  },
  -- Comment using gc
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },
  -- Repeat plugin map (instead of the last native command)
  {
    "tpope/vim-repeat",
    event = "VeryLazy"
  },
  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },
  -- Telescope
  -- (Fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  -- Native telescope sorter
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },

  -- UI Improvement
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      "<space>s",
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree-config")
    end,
  },


  -- Git related Plugins
  -- Fast, beautiful git branch viewer
  {
    "rbong/vim-flog",
    cmd = { "Flog" }
  },
  -- Blames in the sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns-config")
    end,
  },

  -- LSP related
  -- mason.nvim to manage the language servers
  -- They are not exactly dependencies of lspconfig, but they should be
  -- set up before it.
  {
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
					border = "rounded",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd" }
      })
			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({})
				end,
				-- Next, you can provide a dedicated handler for specific servers.
				-- For example, a handler override for the `rust_analyzer`:
				-- ["rust_analyzer"] = function ()
				--     require("rust-tools").setup {}
				-- end
			})
		end,
	},
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp-config")
    end,
  },
  -- Treesitter-based highlighting, use :TSInstall to install languages
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter-config")
    end,
  },
}

local lazy_opts = {
  ui = {
    border = "rounded",
    title = "Lazy Plugin Manager",
    title_pos = "center",
  }
}

require("lazy").setup(plugin_specs, lazy_opts)

-- packer.startup {
--   function(use)
--     use { 'wbthomason/packer.nvim' } -- packer itself
--     use { 'folke/tokyonight.nvim' } -- Tokyonight colortheme
    -- use 'simeji/winresizer' -- resize windows
    -- use 'itchyny/lightline.vim' -- Fancier statusline
    -- vim things picker, the mighty telescope!
    -- use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
    -- use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    -- Ad git related info in the signs columns and popups
    -- use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    -- use 'lukas-reineke/indent-blankline.nvim' -- colorful indent
    -- use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
    -- use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
    -- use {'folke/which-key.nvim'}
    -- use {'ntpeters/vim-better-whitespace'}
    -------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------
    -- neovim lsp and related
    -- use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    -- use 'kabouzeid/nvim-lspinstall' -- install lsp vis LspInstall
    -- use 'hrsh7th/nvim-compe'
    -- use 'windwp/nvim-autopairs' -- auto pairs, woohoo!
    -------------------------------------------------------------------------------------
-- end
-- }

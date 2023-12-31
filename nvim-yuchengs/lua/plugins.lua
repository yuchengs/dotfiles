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

-- Plugin specs other than LSP
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

plugin_specs_lsp = require("config.lsp-config")
merged_specs = utils.merge_table(plugin_specs, plugin_specs_lsp)

local lazy_opts = {
  ui = {
    border = "rounded",
    title = "Lazy Plugin Manager",
    title_pos = "center",
  }
}

require("lazy").setup(merged_specs, lazy_opts)

-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")
  -- Color scheme
  use("folke/tokyonight.nvim")
  use("folke/lsp-colors.nvim")
  use { "catppuccin/nvim", as = "catppuccin" }
  use("lukas-reineke/indent-blankline.nvim")
  -- Treesitter
  use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
  })
  use("nvim-treesitter/playground")
  use("romgrk/nvim-treesitter-context")
  use {
    "windwp/nvim-ts-autotag",
    config = function() require('nvim-ts-autotag').setup() end
   }

  use("mfussenegger/nvim-dap")
  use("rcarriga/nvim-dap-ui")
  use("theHamsta/nvim-dap-virtual-text")
  -- Icons
  use("kyazdani42/nvim-web-devicons")
  --  LSP/Completion
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/nvim-cmp")
  use("onsails/lspkind-nvim")
  use("nvim-lua/lsp_extensions.nvim")
  use("glepnir/lspsaga.nvim")
  use("simrat39/symbols-outline.nvim")
  use("simrat39/rust-tools.nvim")
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("leafOfTree/vim-svelte-plugin")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use {
  "folke/trouble.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
  -- Formatter
  use("sbdchd/neoformat")
  -- Markup
  use("mattn/emmet-vim")
  -- Status Line
  use({
    'nvim-lualine/lualine.nvim',
     requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  })
  -- Menu
  use("gelguy/wilder.nvim")
  -- Tabs
  use({
      "romgrk/barbar.nvim",
     requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  })
  -- Git
  use("tpope/vim-fugitive")
  use("APZelos/blamer.nvim")
  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-file-browser.nvim")
  use("nvim-telescope/telescope-fzy-native.nvim")
  -- Misc
  use("junegunn/fzf")
  use("junegunn/fzf.vim")
  use("tpope/vim-commentary")
  use("mhinz/vim-startify")
  use("nvim-lua/plenary.nvim")
  use("nvim-lua/popup.nvim")
  use("tpope/vim-surround")
  use("mbbill/undotree")
  use("fatih/vim-go")
  use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
   }
   use("mg979/vim-visual-multi")
end)

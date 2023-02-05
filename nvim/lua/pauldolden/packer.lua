-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")
  -- Color scheme
	use 'folke/tokyonight.nvim'
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
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      -- Snippet Collection (Optional)
      {'rafamadriz/friendly-snippets'},
    }
  }
  use("dense-analysis/ale")
  use("github/copilot.vim")
  use("leafOfTree/vim-svelte-plugin")
  use {
  "folke/trouble.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    }
  	end
	}
  -- Formatter
  use("sbdchd/neoformat")
	use("mhartington/formatter.nvim")
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
  use("APZelos/blamer.nvim")
  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-file-browser.nvim")
  use("nvim-telescope/telescope-fzy-native.nvim")
  -- Misc
	use("chentoast/marks.nvim")
	use "fladson/vim-kitty"
  use("lukas-reineke/indent-blankline.nvim")
  use("junegunn/fzf")
  use("junegunn/fzf.vim")
  use("tpope/vim-commentary")
  use("nvim-lua/plenary.nvim")
  use("nvim-lua/popup.nvim")
  use("tpope/vim-surround")
  use("mbbill/undotree")
  -- VimWiki
  use {
      'vimwiki/vimwiki',
      config = function()
          vim.g.vimwiki_list = {
              {
                  path = '~/vimwiki',
                  syntax = 'markdown',
                  ext = '.md',
              }
          }
      end
  }
  use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
 	use("mg979/vim-visual-multi")
end)

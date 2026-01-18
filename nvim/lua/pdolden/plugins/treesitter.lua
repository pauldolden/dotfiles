return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "rust",
        "go",
        "zig",
        "jsdoc",
        "bash",
      },
      sync_install = false,
      auto_install = true,
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Custom parser for templ
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }
      vim.treesitter.language.register("templ", "templ")
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },
  { "nvim-treesitter/nvim-treesitter-refactor",    event = "VeryLazy" },
  { "nvim-treesitter/nvim-treesitter-context",     event = "VeryLazy" },
}

local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "ruby",
    "elixir",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },

  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- Note: those are stored under query/<lang>/textobjects.scm
        -- for query lang docs: https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries
        -- example to do ranges: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/lua/textobjects.scm#L24-L27
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "solargraph",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  filters = {
    dotfiles = false,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M

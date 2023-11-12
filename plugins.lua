local overrides = require("custom.configs.overrides")
local includesRequiredPackage = function(filename, lib)
  return function(ctx)
    local filepath = require("conform.util").root_file({ filename })(ctx)

    if not filepath then
      return false
    end

    local pkgpath = string.format("%s/%s", filepath, filename)
    local file = io.open(pkgpath, "r")

    if not file then
      return false
    end

    local content = file:read("*a")
    file:close()

    if string.match(content, lib) then
      return true -- Pattern found in the file.
    else
      return false -- Pattern not found in the file.
    end
  end
end


---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "tpope/vim-rails",
    lazy = false,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {
    "klen/nvim-test",
    config = function (_, _)
      require("nvim-test").setup({
        run = true,                 -- run tests (using for debug)
        commands_create = true,     -- create commands (TestFile, TestLast, ...)
        filename_modifier = ":.",   -- modify filenames before tests run(:h filename-modifiers)
        silent = false,             -- less notifications
        term = "terminal",          -- a terminal to run ("terminal"|"toggleterm")
        termOpts = {
          direction = "vertical",   -- terminal's direction ("horizontal"|"vertical"|"float")
          width = 96,               -- terminal's width (for vertical|float)
          height = 24,              -- terminal's height (for horizontal|float)
          go_back = false,          -- return focus to original window after executing
          stopinsert = "auto",      -- exit from insert mode (true|false|"auto")
          keep_one = true,          -- keep only one terminal for testing
        },
        runners = {               -- setup tests runners
          ruby = "nvim-test.runners.rspec",
        }
      })
    end;
    keys = {
      { "<leader>tt", function() require("nvim-test").run("file") end, desc = "Run File" },
      { "<leader>tr", function() require("nvim-test").run("nearest") end, desc = "Run Nearest" },
      { "<leader>ts", function() require("nvim-test").run("suite") end, desc = "Run Suite" },
      { "<leader>tl", function() require("nvim-test").run_last() end, desc = "Run Last" },
    }
  };

  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
    keys = {
      { "<leader>hw", function() require("hop").hint_words() end, desc = "Hop Word" },
      { "<leader>hl", function() require("hop").hint_lines() end, desc = "Hop Lines" },
    }
  };

  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>fr",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "prettierd", "prettier" } },
        rust = { "rustfmt" },
        ruby = { { "prettierd", "prettier", "rubocop" } },
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { "sql", "java" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        -- ...additional logic...
        return { timeout_ms = 500, lsp_fallback = true }
      end,

      -- Customize formatters
      formatters = {
        prettierd = {
          condition = includesRequiredPackage("package.json", "@prettier"),
        },
        prettier = {
          condition = includesRequiredPackage("package.json", "@prettier"),
        },
        rubocop = {
          prepend_args = { "--server" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  }

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins

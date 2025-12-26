local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "nvim-snippets",
      enabled = false,
    },

    {
      "mfussenegger/nvim-lint",
      opts = {
        linters = {
          terraform_validate = {
            -- We only need to override the arguments
            args = { "validate", "-json" },
          },
        },
      },
    },

    {
      "saghen/blink.cmp",
      enabled = false,
      build = "cargo build --release",
    },

    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.helm" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.editor.telescope" },

    {
      "folke/tokyonight.nvim",
      opts = {
        dashboard = true,
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      enabled = true,
      opts = {
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 100,
          virt_text_pos = "eol",
        },
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
          topdelete = { text = "-" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
      },
    },
    {
      "hrsh7th/nvim-cmp",
      enabled = true,
      priority = 1000,
      version = false,
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
      },
      opts = function()
        local cmp = require("cmp")
        return {
          completion = {
            completeopt = "menu,menuone,noinsert",
          },
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
          formatting = {
            format = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          },
          experimental = {
            ghost_text = true,
          },
        }
      end,
    },
    -- Add the bashls configuration here
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "bash-language-server",
          "zls",
          "lua-language-server",
          "pyright",
          "typescript-language-server",
          "gopls",
          "astro-language-server",
          "html-lsp",
          "css-lsp",
          "tailwindcss-language-server",
          "terraform-ls",
        },
      },
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
      },
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          bashls = {},
          zls = {},
          astro = {
            filetypes = { "astro" },
          },
          html = {
            filetypes = { "html" },
          },
          cssls = {
            filetypes = { "css", "scss", "less" },
          },
          tailwindcss = {
            filetypes = {
              "astro",
              "html",
              "css",
              "scss",
              "javascript",
              "typescript",
              "react",
            },
          },
          terraformls = {},
        },
      },
    },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.g.clipboard = {
  name = "xsel",
  copy = {
    ["+"] = "xsel --clipboard --input",
    ["*"] = "xsel --primary --input",
  },
  paste = {
    ["+"] = "xsel --clipboard --output",
    ["*"] = "xsel --primary --output",
  },
  cache_enabled = 1,
}

return {
  "folke/snacks.nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      row = 4,
      preset = {
        header = [[
     ██╗ █████╗ ██╗  ██╗ ██████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
     ██║██╔══██╗██║ ██╔╝██╔═══██╗██╔══██╗██║   ██║██║████╗ ████║
     ██║███████║█████╔╝ ██║   ██║██████╔╝██║   ██║██║██╔████╔██║
██   ██║██╔══██║██╔═██╗ ██║   ██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║
╚█████╔╝██║  ██║██║  ██╗╚██████╔╝██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
        keys = {
          {
            icon = "🔍 ",
            key = "f",
            desc = "Find File",
            action = function()
              Snacks.dashboard.pick("files")
            end,
          },
          {
            icon = "📄 ",
            key = "n",
            desc = "New File",
            action = function()
              vim.cmd("ene | startinsert")
            end,
          },
          {
            icon = "🔎 ",
            key = "g",
            desc = "Find Text",
            action = function()
              Snacks.dashboard.pick("live_grep")
            end,
          },
          {
            icon = "🕒 ",
            key = "r",
            desc = "Recent Files",
            action = function()
              Snacks.dashboard.pick("oldfiles")
            end,
          },
          {
            icon = "⚙️ ",
            key = "c",
            desc = "Config",
            action = function()
              Snacks.dashboard.pick("files", {
                cwd = vim.fn.stdpath("config"),
              })
            end,
          },
          {
            icon = "📦 ",
            key = "l",
            desc = "Lazy",
            action = function()
              vim.cmd("Lazy")
            end,
          },
          {
            icon = "❌ ",
            key = "q",
            desc = "Quit",
            action = function()
              vim.cmd("qa")
            end,
          },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },
        {
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
        },
        {
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
  },
}

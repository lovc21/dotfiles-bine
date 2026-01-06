-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "/etc/profiles/per-user/bine/bin/wl-copy",
    ["*"] = "/etc/profiles/per-user/bine/bin/wl-copy",
  },
  paste = {
    ["+"] = "/etc/profiles/per-user/bine/bin/wl-paste --no-newline",
    ["*"] = "/etc/profiles/per-user/bine/bin/wl-paste --no-newline",
  },
  cache_enabled = 1,
}

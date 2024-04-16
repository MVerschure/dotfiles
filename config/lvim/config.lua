-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
reload('user.keymaps')
reload('user.options')
reload('user.plugins')
reload('user.which-key')

-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""
-- local cmp = require "cmp"

-- lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
--   local copilot_keys = vim.fn["copilot#Accept"]()
--   if copilot_keys ~= "" then
--     vim.api.nvim_feedkeys(copilot_keys, "i", true)
--   else
--     fallback()
--   end
-- end


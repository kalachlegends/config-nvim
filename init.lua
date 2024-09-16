-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)
vim.o.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg "", "\n"),
    vim.fn.getregtype "",
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy "+",
    ["*"] = require("vim.ui.clipboard.osc52").copy "*",
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end
require "lazy_setup"
require "polish"
vim.api.nvim_set_keymap(
  "n",
  "<Space>t1",
  ":lua require('toggleterm').exec('', 1)<CR>",
  { noremap = true, silent = true, desc = "Execute ToggleTerm with terminal ID 1" }
)
vim.api.nvim_set_keymap(
  "n",
  "<Space>t2",
  ":lua require('toggleterm').exec('', 2)<CR>",
  { noremap = true, silent = true, desc = "Execute ToggleTerm with terminal ID 2" }
)

-- remap visual block mode
vim.api.nvim_set_keymap("n", "<A-v>", "<C-v>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>mc",
  ":lua require('nvim-code-eval-plugin').choose_server()<CR>",
  { desc = "Choose server from xt-xarid" }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>me",
  ':lua require("nvim-code-eval-plugin").execute("test", require("nvim-code-eval-plugin").get_selection()) <CR>',
  { desc = "Eval code" }
)
vim.api.nvim_set_keymap(
  "v",
  "<leader>ma",
  ':lua require("nvim-code-eval-plugin").execute("all", require("nvim-code-eval-plugin").get_selection()) <CR>',
  { desc = "Eval code everywhere" }
)
function evalCodeFile(var1)
  local filetype = vim.fn.expand "%:e"
  if filetype == "ex" then
    local current_buf = vim.api.nvim_get_current_buf()
    local content = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    require("nvim-code-eval-plugin").execute(var1 or "test", content)
  end
end
vim.api.nvim_set_keymap("n", "<leader>me", ":lua evalCodeFile()<CR>", { desc = "Eval code" })
vim.api.nvim_set_keymap("n", "<leader>ma", ':lua evalCodeFile("all")', { desc = "Eval all" })

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = false,
  virtual_text = false,
  underline = false,
})

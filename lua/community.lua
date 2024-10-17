-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.editing-support.vim-move" },

  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.search.nvim-spectre" },
  -- import/override with your plugins folder
} 

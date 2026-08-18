-- ==================================================
-- 1~ Set Transparency
-- ==================================================

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
  end,
})

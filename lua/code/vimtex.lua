return {
  'lervag/vimtex',
  ft = { 'tex', 'plaintex', 'bib' },
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = 'sioyek'
    -- 取消所有的提示.
    vim.g.vimtex_quickfix_mode = 0
    -- vim.g.vimtex_quickfix_ignore_filters = {
    -- 	"Underfull",
    -- 	"Overfull",
    -- 	"specifier changed to",
    -- 	"Token not allowed in a PDF string",
    -- 	"LaTeX Warning: Float too large for page",
    -- 	"contains only floats",
    -- }
    -- vim.g.vimtex_latexmk_callback_post_compiler_success = ""
  end,
}

return {
  'elentok/format-on-save.nvim',
  opts = function()
    local formatters = require('format-on-save.formatters')

    return {
      exclude_path_patterns = {
        "/node_modules/",
        ".local/share/nvim/lazy",
      },

      fallback_formatter = {
        formatters.remove_trailing_whitespace,
        formatters.remove_trailing_newlines,
      },

      formatter_by_ft = {
        -- LSP
        lua = formatters.lsp,
        go = formatters.lsp,
        rust = formatters.lsp,
        haskell = formatters.lsp,

        -- Custom
        typescript = formatters.prettierd,
        javascript = formatters.prettierd,
        typescriptreact = formatters.prettierd,
        javascriptreact = formatters.prettierd,
        markdown = formatters.prettierd,
        sh = formatters.shfmt,
      }
    }
  end
}

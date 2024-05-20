local M = {}

function M.set(opts)
  M.methods = opts.methods or {
      diagnostics = true,
      formatting = true,
      code_actions = true,
      completion = true,
      hover = true,
    } -- source types to load. set to false to ignore.
    M.handlers = opts.handlers or {} -- handlers to use aditionally to the ones from mason.
    M.external_sources = opts.external_sources or {} -- extra sources to look for. formatted as { { '<package_name>', 'module_path' } }

    -- expose config globally
    vim.g.none_ls_autoload_config = M
end

return M

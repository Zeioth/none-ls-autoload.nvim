-- Entry point of the program.
local utils = require('none-ls-autoload.utils')
local M = {}

function M.setup(opts)
	-- Apply config
	local settings = require('none-ls-autoload.config')
	settings.set(opts)

	-- Call functions
  utils.autoload_sources()
end

return M

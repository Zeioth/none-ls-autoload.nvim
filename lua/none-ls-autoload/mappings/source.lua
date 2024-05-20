-- Library to convert betwen mason and none-ls names.

-- mason functional programming libraries.
local _ = require('mason-core.functional')
local o = require('mason-core.optional')

local M = {}

-- Maps mason package names to its none-ls name for the packages that need it.
local package_to_none_ls = {
	['cmake_lint'] = 'cmakelint',
	['cmake_format'] = 'cmakelang',
	['eslint_d'] = 'eslint_d',
	['goimports_reviser'] = 'goimports_reviser',
	['phpcsfixer'] = 'php-cs-fixer',
	['verible_verilog_format'] = 'verible',
	['lua_format'] = 'luaformatter',
	['ansiblelint'] = 'ansible-lint',
	['deno_fmt'] = 'deno',
	['ruff_format'] = 'ruff',
	['xmlformat'] = 'xmlformatter',
}

-- Helpers to convert between mason and none-ls.
-- -----------------------------------------------------------

---Given a mason pkg name, use its none-ls source name equivalent.
---@return string name none-ls source name.
M.get_none_ls_source_name = _.memoize(function(source)
	local name = o.of_nilable(
		package_to_none_ls[source]):or_else_get(
  		_.always(source:gsub('%_', '-')
  	)
	)

	return name
end)

return M

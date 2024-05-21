-- General utilities.

--    Functions:
--      -> get_builtin_handler      → Get a function to load a builtin.
--      -> register_external_source → Try to load a external source.
--      -> filter_methods           → Add autocmds to a bufnr.
--      -> load_source              → Load a single source.
--      -> autoload_sources         → Main utility function that load all sources.

local none_ls = require('null-ls')

-- mason functional programming libraries.
local f = require('mason-core.functional')
local o = require('mason-core.optional')

local M = {}

-- Private functions
-------------------------------------------------------------------------------

---If the user has defined a none-ls external source in the config, load it.
---@param source_name string source name to register a external source for.
---@return boolean was_registered true if there actually was a external source to load.
local function register_external_source_if_available(source_name)
  local was_registered = false

	-- for every external source the user has defined in the config.
	for _, external_source in ipairs(vim.g.none_ls_autoload_config.external_sources) do
		-- extract its name and method.
		local external_source_name = string.gsub(string.match(external_source, '([^%.]+)$'), '_', '-') -- last . substring
		local external_source_method = string.match(external_source, '([^%.]+)%.[^%.]+$') -- penultimate . substring (formatting, diagnostics...)

		-- populate a table of methods we allow (formatting, diagnostics...)
		local allowed_methods = {}
		for method, enabled in pairs(vim.g.none_ls_autoload_config.methods) do
			if enabled then
				table.insert(allowed_methods, method)
			end
		end

		-- if there is a external source available for the current source, and it's a method we allow, register it.
		f.filter_map(function(method)
			if source_name == external_source_name and method == external_source_method then
          if not none_ls.is_registered(external_source) then
  					require('null-ls.sources').register(require(external_source))
  				end
				return o.of(method)
			else
				return o.empty()
			end
		end, allowed_methods)
	end

	return was_registered
end

---The function that register the none-ls source.
---@param source string none-ls source to load.
---@param methods string[] accepted values of for table are "diagnostics", "formatting", "code_actions", "completion", "hover",
local get_builtin_handler = function(source, methods)
	if not none_ls.is_registered(source) then
		vim.tbl_map(function(method)
			none_ls.register(none_ls.builtins[method][source])
		end, methods)
	end
end

---Given a none-ls source_name, it returns its list of methods, based on the
---config option 'methods', ensuring it's formatted correctly.
---It only work for builtins.
---@param source_name string name of the source to get its methods for.
---@return string[] methods a table of methods. For example: { "formatting", "diagnostics", ... }
local function filter_methods(source_name)
-- populate a table of methods the user allow (formatting, diagnostics...)
	local allowed_methods = {}
	for method, enabled in pairs(vim.g.none_ls_autoload_config.methods) do
		if enabled then
			table.insert(allowed_methods, method)
		end
	end
	-- given a source_name, return a table with the methods matching the builtin.
	local methods = f.filter_map(function(method)
		local ok, _ = pcall(require, string.format('null-ls.builtins.%s.%s', method, source_name))
		if ok then
			return o.of(method)
		else
			return o.empty()
		end
	end, allowed_methods)

	return methods
end

---Helper function that load the specified none-ls source.
---@param source_name string
local function load_source(source_name)
	local handlers = vim.g.none_ls_autoload_config.handlers or {}
	local builtin_handler = o.of_nilable(handlers[1]):or_(f.always(o.of_nilable(get_builtin_handler)))

	-- Given a handler
	o.of_nilable(handlers[source_name]):or_(f.always(builtin_handler)):if_present(function(handler)
		-- List of methods to source (linting, formatting...)
		local methods = filter_methods(source_name)

		-- Register external source.
  	local external_source_available = register_external_source_if_available(source_name)

		-- Load builtin source.
		if not external_source_available then -- you can remove this condition if you want to allow both, instead of externals prevailing over builtins.
  		local ok, err = pcall(handler, source_name, methods)

			-- If it didn't load correctly, send a notification.
			if not ok then
				vim.notify(err, vim.log.levels.ERROR)
			end
    end

	end)
end

-- Public functions
-------------------------------------------------------------------------------

---For every installed mason package, register it on none-ls.
function M.autoload_sources()
	---Helper function: Given a mason pkg name, return its none-ls source name.
	---@param mason_pkg_name string
	---@return string none_ls_source_name
	local function get_none_ls_source_name(mason_pkg_name)
		local mappings_lib = require('none-ls-autoload.mappings.source')
		local none_ls_source_name = mappings_lib.get_none_ls_source_name(mason_pkg_name)

		return o.of_nilable(none_ls_source_name) -- return as pipeable object.
	end -- end of the helper function

	-- Main functionality
	local mason_installed_pkgs =
			f.filter_map(get_none_ls_source_name, require('mason-registry').get_installed_package_names())
	f.each(load_source, mason_installed_pkgs)

	-- Extra feature: Also register source on mason package installed.
	require('mason-registry'):on(
		'package:install:success',
		vim.schedule_wrap(function(pkg)
			get_none_ls_source_name(pkg.name):if_present(load_source)
		end)
	)

	-- Extra feature: Also deregister source on mason package uninstalled.
	require('mason-registry'):on(
		'package:uninstall:success',
		vim.schedule_wrap(function(pkg)
	  	require('null-ls.sources').deregister(pkg.name)
		end)
	)
end

return M

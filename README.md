# [none-ls-autoload](https://github.com/Zeioth/none-ls-autoload.nvim)
Minimalistic alternative for the plugin `mason-null-ls` with support for external sources.

## Table of contents

- [Why](#why)
- [How to install](#how-to-install)
- [How to use none-ls external sources](#how-to-use-none-ls-external-sources)
- [Available options](#available-options)
- [FAQ](#faq)

## Why
**Problem**:
* Normally when you use none-ls you would have to manually register the sources you want to load.
* You would also have to manually deregister sources when you uninstall them, or none-ls will display errors.

**Solution**:
* By using `none-ls-autoload.nvim`, you don't have to worry anymore! This plugin will take care of automatically load/unload all mason packages you install/uninstall when necessary.

## How to install

```lua
{
  "zeioth/none-ls-autoload.nvim",
  event = "BufEnter",
  dependencies = { "williamboman/mason.nvim" },
  opts = {},
},
```

## How to use none-ls external sources
**What are they?** The `none-ls` project stop supporting builtin sources when they have not been maintained for a while. Knowing that: External sources are packages you can install sources not oficially supported by `none-ls`.

**How do I install them?** You install the dependency, and tell `none-ls-autoload.nvim` where to find it with the option `external_sources`.

```lua
{
  "zeioth/none-ls-autoload.nvim",
  event = "User BaseFile",
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls-extras.nvim" -- Example of installing a external sources library.
  },
  opts = {
    external_sources = {
      'none-ls.formatting.reformat_gherkin' -- Example of telling none-ls-autoload where to find a external source.
    },
  },
},
```

**How does it work?** It's IMPORTANT to be aware a external source is just a way to tell none-ls how to use a mason package. You HAVE to install the mason package to use it.

## Available options

| Option | Default | Description|
|--|--|--|
| `external_sources` | `{}` | If a mason package is not directly supported through a none-ls builtin source, you can specify a external source, so none-ls-autoload.nvim` know how to load/unload it automatically when needed. |
| `methods` | `{ diagnostics = true, formatting = true, code_actions = true, completion = true, hover = true }` | The type of sources we should load. This is handy in case you want to disable a certain kind of client. Or in case you want to manage a certain functionality using a different plugin. |

## FAQ

* **Do I need mason for this plugin to work?** Yes.
* **Will this plugin interfere with my none-ls options?** No.
* **How is this plugin different from mason-null-ls?** Only a couple things. We add a new feature: support for external sources. We remove a feature: We don't provide commands to manually load/unload sources, as we do it automatically anyway. Aditionally, we aim to keep the code easier to understand and contribute to.
* **My external none-ls source doesn't load correctly**: The source you pass must be formated like `'<anything-you-want>.<method>.<source-name>'`, as we extract the last two fields to load it. For example `'package_name.subdirectory.formatting.reformat_gherkin'`. So if the external source you are trying to pass come from a repository not formatted that way, just fork it and fix it's directory structure.

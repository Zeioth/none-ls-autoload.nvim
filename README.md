# [none-ls-autoload](https://github.com/Zeioth/none-ls-autoload.nvim)
Minimalistic alternative for the plugin `mason-null-ls` with support for external sources.

## Table of contents

- [Why](#why)
- [How to install](#how-to-install)
- [How to use external sources](#how-to-install-external-sources)
- [Available options](#available-options)
- [FAQ](#faq)

## Why
**Problem**:
* Normally when you use none-ls you would have to manually register the sources you want to load.
* You would also have to manually deregister sources when you uninstall them, or none-ls will fail.

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

## How to use external sources
**What are they?** none-ls periodically stop supporting builtin sources that have not been maintained for a while. What happen if we still need to use them? External sources is the answer! 

**How do I install them?** You install the dependency, and tell `none-ls-autoload` where to find it with the option `external_sources`.

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

**How does it work?** It's IMPORTANT to be aware a external source is just a way to tell none-ls to know how to use a mason package. You HAVE to install the mason package to use it.

## Available options

| Option | Default | Description|
|--|--|--|
| `external_sources` | `{}` | If a mason package is not directly supported through a none-ls builtin source, you can specify a external source, so none-ls-autoload` know how to load/unload it automatically when needed. |
| `methods` | `{ diagnostics = true, formatting = true, code_actions = true, completion = true, hover = true }` | The type of sources we should load. This is handy in case you want to disable a certain kind of client. Or in case you want to manage a certain functionality using a different plugin. |

## FAQ

* **Do I need mason for this plugin to work?** Yes.
* **Will this plugin interfere with my none-ls options?** No.
* **How is this plugin different from mason-null-ls?** Couple things. We support external sources. We don't provide commands to manually load/unload sources, as we do it automatically anyway.

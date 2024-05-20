# none-ls-autoload
Minimalistic alternative for the plugin `mason-null-ls` with support for external sources.

Normally when you use none-ls you have to manually add the sources you want to load to the option 'sources'. 

But with `none-ls-autoload.nvim`, you don't have to! This plugin take care of automatically load all mason packages you have installed for the current filetype for you.

## Table of contents

- [Why](#why)
- [How to install](#how-to-install)
- [How to use](#how-to-use)
- [How to use with external sources](#how-to-use-with-external-sources)
- [Available options](#available-options)
- [FAQ](#faq)

## Why
**Problem**
Normally when you use none-ls you have to manually add the sources you want to load to the option 'sources'. 

**Solution**:
* `none-ls-autoload.nvim`, automatically load your none-ls sources in a smart way, so you don't have to configure anything.
* This way you can start using the packages you install on `mason` without having to worry about manually registering them.

## How to install

```lua
{
  "zeioth/none-ls-autoload.nvim",
  event = "User BaseFile",
  dependencies = {
    "williamboman/mason.nvim",      -- is used by this plugin.
    "nvimtools/none-ls-extras.nvim" -- library of external none-ls sources.
  },
  opts = {
    external_sources = {
      'none-ls.formatting.reformat_gherkin'
    },
  },
},
```

## how to use
* `none-ls-autoload` will load your mason packages using `none-ls` right when it's necessary, and it will unload them when they are not. Which none-ls is not capable of doing by itself, because it doesn't depend on mason.

## External sources with external sources
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

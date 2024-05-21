# [none-ls-autoload.nvim](https://github.com/Zeioth/none-ls-autoload.nvim)
Minimalistic alternative for the plugin `mason-null-ls` with support for [none-ls](https://github.com/nvimtools/none-ls.nvim) [external sources](https://github.com/nvimtools/none-ls-extras.nvim?tab=readme-ov-file#related-projects).

<div align="center">
  <a href="https://discord.gg/ymcMaSnq7d" rel="nofollow">
      <img src="https://img.shields.io/discord/1121138836525813760?color=azure&labelColor=6DC2A4&logo=discord&logoColor=black&label=Join the discord server&style=for-the-badge" data-canonical-src="https://img.shields.io/discord/1121138836525813760">
    </a>
</div>

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
* By using `none-ls-autoload.nvim`, you don't have to worry about any of that. This plugin will take care of automatically load/unload all mason packages you install/uninstall when necessary.

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
### What are they?

The `none-ls` project [stop supporting builtin sources](https://github.com/nvimtools/none-ls.nvim/discussions/81) when they have not been maintained for a while. Knowing that: External sources are packages you can install to use sources not oficially supported by `none-ls`.

### How to install them

* You install the dependency.
* Then you tell `none-ls-autoload.nvim` where to find it with the option `external_sources`.

```lua
{
  "zeioth/none-ls-autoload.nvim",
  event = "User BaseFile",
  dependencies = {
    "williamboman/mason.nvim",
    "zeioth/none-ls-external-sources.nvim" -- To install a external sources library.
  },
  opts = {
    external_sources = {
      -- To specify where to find a external source.
      'none-ls-external-sources.formatting.reformat_gherkin'
    },
  },
},
```

It's important to be aware a source is just a way to tell none-ls how to use a mason package. You HAVE to install the mason package to use it.

## Available options

| Option | Default | Description|
|--|--|--|
| `external_sources` | `{}` | If a mason package is not directly supported through a none-ls builtin source, you can specify a external source, so `none-ls-autoload.nvim` know how to load/unload it automatically when needed. |
| `methods` | `{ diagnostics = true, formatting = true, code_actions = true, completion = true, hover = true }` | The type of sources we should load. This is handy in case you want to disable a certain kind of client. Or in case you want to manage a certain functionality using a different plugin. |

## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/Zeioth/none-ls-autoload.nvim.svg)](https://starchart.cc/Zeioth/none-ls-autoload.nvim)

## FAQ

* **Do I need mason for this plugin to work?** Yes.
* **Do this plugin interfere with my none-ls options?** No.
* **How is this plugin different from mason-null-ls?** Only a couple things. We add a new feature: support for external sources. We remove a feature: We don't provide commands to manually load/unload sources, as we do it automatically anyway. Aditionally, we aim to keep the code easier to understand and contribute to.
* **My external none-ls source doesn't load correctly**: The source you pass must be formated like `'<anything-you-want>.<method>.<source-name>'`, as we extract the last two fields to load it. For example `'package_name.subdirectory.formatting.reformat_gherkin'`. So if the external source you are trying to pass come from a repository not formatted that way, just fork it and fix its directory structure.
* **Where can I find external sources?**: [Here](https://github.com/Zeioth/none-ls-external-sources.nvim).

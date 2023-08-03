# hmts.nvim

This neovim plugin allows (thanks to treesitter) highlighting languages contained in strings in various places of a Home
Manager configuration `nix` file.

## What it does

Often in a nix configuration, and in particular with home manager, you find yourself inlining files in arbitrary
languages as strings. This, by default, gets highlighted as a plain, boring string. This plugin uses treesitter queries
to inject the actual language used within the screen, enabling proper highlighting of the language within.

> [!Note]
> The default `nix` queries from the nvim-treesitter first-party plugin do come with a few injections, but only the
> trivial ones. Properly detecting more complex stuff requires some lua code, which is what is done in hmts.nvim.

Here's an example of the difference it can make:
| Default behavior | With hmts.nvim |
|------------------|-------------------------|
|![image](https://github.com/calops/hmts.nvim/assets/4097716/cb71e7e2-f85c-4380-b2ff-127738230d63)|![image](https://github.com/calops/hmts.nvim/assets/4097716/220cd490-9bf2-44e8-962e-59f548861cf4)|

## Requirements

- Neovim `0.9` (probably works on older versions, if anybody wants to check)
- Have [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) enabled

> [!Important]
> Make sure all the languages you embed are *actually installed in treesitter*, with `:TSInstall`. Don't be me, don't
> spend hours trying to figure out while your injections don't work when the parsers aren't even installed.

## Installation

Install `calops/hmts.nvim` with your favorite package manager.

**Example with `lazy.nvim`**:
```lua
{
    "calops/hmts.nvim",
    version = "*",
    ft = "nix",
}
```

> [!Note]
> It is recommended to follow *releases* (all numbered with a semver tag, looking like `vX.X.X`) instead of the raw
> `main` branch, as things are expected to break occasionally there. This is done in `lazy.nvim` with `version = *` (you
> can choose a more specific version if you prefer).

## Configuration

You're done already.

## Usage

Just live your life. There is nothing to do, the plugin works out-of-the-box on everything it can identify in your `nix`
files.

## FAQ

> Don't I need to...

No. No, you don't need to call a `setup()` function. But there's still one (that does nothing) if you really feel
compelled to. It won't break anything.

## Contribute

Very few programs are handled right now, but I welcome any addition. Just look through 
[the injections file](./queries/nix/injections.scm) and copy what's already there. It should be pretty straightforward 
for most things. If it isn't, don't hesitate to open an issue.

## TODO

- [ ] Better description in the readme
- [ ] Screenshots in the readme
- [ ] Benchmark the performance impact and see if the queries can be optimized
- [ ] Check the stuff that's already done on the to-do list
- [ ] Add stuff to the todo list

# hmts.nvim
This neovim plugin allows (thanks to treesitter) highlighting languages contained in strings in various places of a Home
Manager configuration `nix` file.

## Installation

Install `calops/hmts.nvim` with your favorite package manager.
**Example with `lazy.nvim`**:
```lua
{
    "calops/hmts.nvim",
    ft = "nix",
}
```

## Usage

Just live your life. There is nothing to do, the plugin works out-of-the-box on everything it can identify in your `nix`
files.

## FAQ

> Don't I need to...

No. No, you don't need to call a `setup()` function. But there's still one (that does nothing) if you really feel
compelled to. It won't break anything.

## TODO

- [ ] Check the stuff that's already done on the to-do list
- [ ] Better description in the readme
- [ ] Screenshots in the readme
- [ ] Benchmark the performance impact and see if the queries can be optimized
- [ ] Add stuff to the todo list

# Neo Vim

## Configuration

- Stored in `~/.config/nvim`
- entrypoint `init.lua`
- create a folder named `lua/<whatever>` inside `~/.config/nvim`
- create a file in `lua/<whatever>/something.lua`
- now you can `require("<whatever>.something")` 
- you can use this to organize your configurations

## Packages

Neovim has a bast packages ecosystem, you could download the files and add them to your repo, but normally you would use a package manager, the more used ones are [Packer](https://github.com/wbthomason/packer.nvim) and [Lazy](https://github.com/folke/lazy.nvim)


### Lazy.nvim
- Loads packages in a lazy form -> meaning until certain event/keystroke is not done the package is not loaded -> improving time load time of neovim

1. copy the bootstrap from lazy.nvim page 
2. `require("lazy").setup("plugins")
3. `~/.config/lua/plugins/init.lua` and any `~/config/lua/plugins/*.lua` will be loaded and the return added to the configuration of plugin_spec


### Telescope
- a fuzzy finder for searching files/tabs etc...

### TreeSitter

is a file parser that will give a better idea to neovim what is each part of the file.

It has different "parsers" for differents files, so you have to activate differents languages to download each parser.

You can install new parser with `:TSInstall <language>` or modify your vim treesitter configuration and add the `ensure_language` 

### TreeSitter - TextObjects

A library that give you access to the token, with it you can do things like "auto increment selection" or select the whole function/class etc...

### TreeSitter - Playground

Plugin that give you `:TSPlaygroundToggle` so you can see the AST of your file, helpful if you build plugins or if you want to create a custom function using TreeSitter - TextObjects


### TreeSitter - nvim-ts-context-commentstring
changes commentstring setting of treesitter for when using files that have multiple filetypes (vue/jsx etc..)

You need to use another plugin to actually comment lines.

### Comment.nvim

Give the ability to comment current line with `gcc`

### Lsp-zero + Mason

Allow to configure LSP + cmp + Mason in an easy way

- LSP => to show autocomplete and go to defition
- Mason => to install LSP server executables
- CMP => to show completion

### NeoDev
To configure `lua_ls` with knowledge of where to find neovim api, so lua_ls can be helpful while building plugins or your config

## LSP (Language server programs)
Comes from the world of VisualStudio code, and is used to abstract the editor from how to manage the code of a certain language.

So there is a lsp for each language, and neovim (or any editor) can connect to it, and know exactly if there are error, go to definition, show documentation etc... these are the capabilities.

Maintaining a list of all lsp servers is complicated that why there are projects like `mason` that install the lsp servers you want.

Also to show the options of each lsp you need to use some kind of ui (telescope has some, or you can use `cmp`)

all of this is hard to configure, that why there is `lsp-zero.nvim`. And one of the best thing is that it explains exactly what is going on under the hood



## Movements

- `G/gg`: go end of file, start of file
- `w/W:b/B`
- `v/shift+V`: go to selection mode or line selection mode
- `d`: delete + movevemnt
- `ctrl-i/ctrl-o`: jump between last cursor position
- `<<` or `>>`: indents the current line / selection
- `0` and `$`: begining of line or end of line
- `t` and `f`: t + character -> will move the cursor until the caractor, `f+char` will move and the cursor will be under the character.
- `T` and `F`: equal to `f` and `f` but goes backward
- `(` and `)`: move sentences backward and forward
- `{` and `}`: move to next/prev paragraph
- `[[` `]]`: move to next/prev "section"
- C-^: alternate files (open prev buffer)
- C-d/C-u: move half page up and down
## Autocommand 

Allow to execute some code when an specific event is sent for example 
- `BufWritePre` => before writing the file
- `Filetype` => when changing the file type
- `BufReadPost` => After reading a file on a buffer

Autocommands can be grouped in "groups", so it's easier to delete the whole group

The events have some data, that you can patter match for example, when reading a .c or a .h file set specific parameters

```
:autocmd cprograms BufReadPost *.c,*.h :set sw=4 sts=4
```
see the [Neovim documentation](https://neovim.io/doc/user/usr_40.html#40.3) for more info
## NetRW

Is the list of files that comes with neovim

- `%`: create file
- `d`: create directory
- `D`: delete file
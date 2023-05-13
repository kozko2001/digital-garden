Tmux
====

Tmux is a multiplexer -> allows to use a single terminal as multiple ones

## Concepts

- Pane: a division of the current window, both panes can be shown at the same time
- Window: You can dispose of different windows (like tabs) but only one window can be shown at the same time
- Session: Abstraction to disconnect your tty from the shell, you can connect to your tmux session from different terminals like ssh, and when the terminal is close the session still alive and can be retached

## Basic keybindings

Leader: <ctrl-b> is the prefix of all actions

- `<leader> "`: create pane horitzontally
- `<leader> %`: create pane vertically
- `<leader> <left/right/up/down>`: select pane
- `<leader> z`: zoom the pane
- `<leader> 0/9`: select window 0, 1, 2...
- `<leader> n/p`: go to next/prev window
- `<leader> ?`: show keybindings
- `<leader> ,`: rename current window
- `<leader> c`: create window
- `<leader> [`: enter scroll mode
- - `ctrl-r`: start search reverse (up)
## Plugins and configurations

People can develop plugins for tmux, I suggest to use the TPM (Tmux Plugin manager)

And since tmux is a little bit barebone I am using oh-my-tmux which already install tpm

```
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
```


## Troubleshoot

## Resources
- [Quick and Easy guide to tmux - Ham Vocke](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
- [Oh my tmux](https://github.com/gpakosz/.tmux)
- [Introduction to tmux - perl](https://www.perl.com/article/an-introduction-to-tmux/)

# Dotfiles for JY's setup

This repo uses [`chezmoi`](https://github.com/twpayne/chezmoi) to manage dotfiles and per-machine configs.

Install them with

```console
$ chezmoi init jeanyvesb9
```

Personal secrets are stored in [BitWarden](https://bitwarden.com), and you'll need the BW CLI installed.

## CERN LXPlus

When setting up new isolated systems, copy `/eos/user/j/jbeaucam/packages/dot_local_backup` to `$HOME/.local`.

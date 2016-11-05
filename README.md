# Promptheus

A shell prompt for bash and zsh.

![Screenshot](screenshot.png?raw=true)


## Features
* autojump `cd` to previous directories (history)  
* working directory with write permission color
* return code of previous failed command
* git/svn branch and status
* root user color indicator
* current time

## Install Instructions
Just source the `.promptheusrc` in your `.bashrc` or `.zshrc`

```bash
   # load promptheus theme
   source .promptheusrc 
```

## Aliases
Promptheus defines a small set of handy aliases

`..`, `...`, `.....` to `cd` upwards

`ff PATTERN` find file with PATTERN

`fif PATTERN` find all occurrences of PATTERN in files

`x FILE` to extract any archive FILE


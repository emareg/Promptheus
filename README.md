# Promptheus

A lighweight shell prompt for `bash`, `zsh`, `fish` and more.

![Screenshot](screenshot.png?raw=true)


## Features
* displays login information
* shell/user sign:
	- `$` for bash
	- `%` for zsh
	- `§` for fish
	- `>` for sh / ksh / dash
	- `)` for csh/tcsh
	- `#` for root in any shell
* working directory with write permission color
* return code of previous failed command
* git branch and status
* current time
* number of running background jobs
<!-- * autojump `cd` to previous directories (history)   -->


## Install Instructions
Just source the `.promptheusrc` in your `.bashrc` or `.zshrc`

```bash
source ~/.promptheus/rc.sh
```

For fish: `source ~/.promptheus/rc.fish`


### Styles
Promptheus provides two default prompt styles that can be set by calling

* `ptSslim` for a functional single line prompt (default)
* `ptSfull` for a fancy two line prompt



## Aliases
Promptheus defines a small set of handy aliases

`..`, `...`, `.....` to `cd` upwards

`ff PATTERN` find file with PATTERN

`fif PATTERN` find all occurrences of PATTERN in files

`x FILE` to extract any archive FILE


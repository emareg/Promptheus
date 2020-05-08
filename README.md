# Promptheus

A lightweight shell prompt for `bash`, `zsh`, `fish` and more.

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
* git branch and status: 
	- `⑂BRANCH`: if `BRANCH` is not `master`
	- `↑`: local branch ahead origin
	- `↓`: local branch behind origin (after `git fetch`)
	- `+`: uncommited changes
	- `…`: untracked files
* current time
* number of running background jobs, e.g `[1&]`
<!-- * autojump `cd` to previous directories (history)   -->


## Install Instructions
**The Easy Way:** Simply run
```bash
wget -O - https://raw.githubusercontent.com/emareg/Promptheus/master/install.sh | sh
```
or
```bash
curl https://raw.githubusercontent.com/emareg/Promptheus/master/install.sh | sh
```

**Manually:**
```bash
git clone git@github.com:emareg/Promptheus.git
cp -r ./Promptheus/.promptheus "$HOME/"
echo 'source ~/.promptheus/rc.sh # Promptheus Theme' >> ~/.bashrc
echo 'source ~/.promptheus/rc.sh # Promptheus Theme' >> ~/.zshrc
echo 'source ~/.promptheus/rc.fish # Promptheus Theme' >> ~/.config/fish/config.fish
```


### Styles
Promptheus provides two default prompt styles that can be set by calling

* `ptSslim` for a functional single line prompt (default)
* `ptSfull` for a fancy two line prompt



## Aliases
Promptheus defines a small set of handy aliases

* `..`, `...`, `....` to `cd` upwards
* `ff PATTERN` find file with PATTERN
* `fif PATTERN` find all occurrences of PATTERN in files
* `extract ARCHIVE` to extract any archive FILE


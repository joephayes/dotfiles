# Joe's dotfiles

## Installation

```bash
cd ~
git clone https://github.com/joephayes/dotfiles.git && cd dotfiles && ./bootstrap.sh
```
### Notes for Windows
On Windows, I use the Git Bash that is part of
[Git Extensions](http://sourceforge.net/projects/gitextensions/). So that
[bootstrap.sh](bootstrap.sh) can create symbolic links correctly, make sure you
run [Git Bash as an Administrator](http://technet.microsoft.com/en-us/magazine/ff431742.aspx).
Otherwise you will get errors similar to

> You do not have sufficient privilege to perform this operation.

## Updating

```bash
cd ~/dotfiles
./bootstrap.sh
```

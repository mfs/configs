## Dotfiles

My Linux dotfiles.

__Note:__ _Currently rewriting this and switching to a macro based system. Will document this soon._

Previously I was storing my configs in `~/configs` and using symlinks to link
them into place. This worked though the whole symlink thing was a bit of a
nuisance. It was an extra step that was required. Recently I came across a
[better way][1] using a bare git repo. Configs are stored in `~/.cfg` as a bare
git repo and are checked out directly into the home directory. This relies on a
couple of things.

First clone your configs as a bare repo:

`git clone --bare <git-repo-url> $HOME/.cfg`

Then define an alias:

`config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`

This tells git to use `~/.cfg` as the repo and `~` as the working directory.
Next tell git to ignore untracked files using the above alias:

`config config --local status.showUntrackedFiles no`

You can then interact with the git repo using `config` and standard git commands
such as `config ls-files`, `config diff`, `config commit`, etc.

See the link above for a full description of how this works.

[1]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

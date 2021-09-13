# XDG dotfiles

This repo intends to organize dotfiles into the `$XDG_CONFIG_HOME` directory, following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and simply version control said directory.
It relies heavily on information collected in the [ArchWiki XDG Base Directory page](https://wiki.archlinux.org/title/XDG_Base_Directory).
Note that the .gitignore file ignores _everything_, thus, `git add` must be run for all new files in order to be tracked.
A private git submodule, which links to a private git repo, is used to version control private config files.

# Installation

The instructions below sets `$XDG_CONFIG_HOME` to its default `"${HOME}/.config"` location and assumes that this directory is not empty, but not already under version control.
The user will be prompted to clean up any file conflicts.

```bash
export XDG_CONFIG_HOME="${HOME}/.config"
mkdir --parents "${XDG_CONFIG_HOME}" && cd "${XDG_CONFIG_HOME}"

# [How do I clone into a non-empty directory?](https://stackoverflow.com/a/18999726/13019084)
# [How to clone a git repo to an existing folder (not empty)](https://gist.github.com/ZeroDragon/6707408#gistcomment-3235804)
git init
git remote add origin 'git@github.com:delannoy/.config.git'
git fetch
git checkout --track origin/main # [When creating a new branch, set up "upstream" configuration. If no -b option is given, the name of the new branch will be derived from the remote-tracking branch](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt---track)
# git checkout --track origin/main -b main # [Specifying -b causes a new branch to be created as if git-branch[1] were called and then checked out.](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutem-b-Bltnewbranchgtltstartpointgt)
# git checkout --track origin/main -B main # [If -B is given, <new_branch> is created if it doesn't exist; otherwise, it is reset](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutem-b-Bltnewbranchgtltstartpointgt)

[[ "$(grep --count '${HOME}/.config/bash/profile' "${HOME}/.profile" 2>/dev/null)" != 1 ]] && echo 'source "${HOME}/.config/bash/profile"' >> "${HOME}/.profile"
[[ "$(grep --count '${HOME}/.config/bash/bashrc' "${HOME}/.bashrc" 2>/dev/null)" != 1 ]] && echo 'source "${HOME}/.config/bash/bashrc"' >> "${HOME}/.bashrc"
```

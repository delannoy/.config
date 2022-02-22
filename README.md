# XDG dotfiles

This repo aims to organize dotfiles into the `$XDG_CONFIG_HOME` directory, following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and simply version control said directory.
It relies heavily on information collected in the [ArchWiki XDG Base Directory page](https://wiki.archlinux.org/title/XDG_Base_Directory).
Note that the .gitignore file ignores _everything_, thus, `git add` must be run for all new files in order to track them.
A private git submodule, which links to a private git repo, is used to version control private config files.

# Installation
The instructions below set `$XDG_CONFIG_HOME` to its default location (`${HOME}/.config`).
If the `${HOME}/.config` directory aleady exists, it is moved/renamed to `${HOME}/.config.bkp`.
The public repo is cloned into `$XDG_CONFIG_HOME`.
A `private` submodule is cloned within `$XDG_CONFIG_HOME`.
Then, the contents of `${HOME}/.config.bkp` (if present) are copied to `${HOME}/.config`, where the user can check for any file conflicts.
Finally, `${HOME}/.bash_profile`, `${HOME}/.bash_login`, `${HOME}/.profile`, and `${HOME}/.bashrc` are moved/renamed (if they are present) and replaced with `${HOME}/.profile`, which simply sources `${HOME}/.config/bash/profile`.

```shell
export XDG_CONFIG_HOME="${HOME}/.config"
[[ -d "${XDG_CONFIG_HOME}" ]] && mv --verbose --interactive "${XDG_CONFIG_HOME}" "${XDG_CONFIG_HOME}.bkp"

user='delannoy'
git clone "git@github.com:${user}/.config.git" "${XDG_CONFIG_HOME}"
cd "${XDG_CONFIG_HOME}"
git submodule add "git@github.com:${user}/private.git" # [Using Git Submodules for Private Content](https://www.taniarascia.com/git-submodules-private-content/)
# git submodule init

[[ -d "${XDG_CONFIG_HOME}.bkp" ]] && mv --verbose --interactive "${XDG_CONFIG_HOME}.bkp/"* "${XDG_CONFIG_HOME}/"

for file in bash_profile bash_login profile bashrc; do [[ -f "${HOME}/.${file}" ]] && mv --verbose --interactive "${HOME}/.${file}" "${XDG_CONFIG_HOME}/bash/${file}.bkp"; done

echo 'source "${HOME}/.config/bash/profile"' > "${HOME}/.profile";
```

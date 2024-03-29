# XDG dotfiles

This repo aims to organize dotfiles into the `$XDG_CONFIG_HOME` directory, following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and simply version control said directory.
It relies heavily on information collected in the [ArchWiki XDG Base Directory page](https://wiki.archlinux.org/title/XDG_Base_Directory).
A private git submodule is used to version control private config files.

# Installation

```bash
# set `$XDG_CONFIG_HOME` to its default location (`$HOME/.config`)
export XDG_CONFIG_HOME="${HOME}/.config"

# if it already exists, rename `$XDG_CONFIG_HOME` directory to `$XDG_CONFIG_HOME.bkp`; otherwise, create the backup directory
[[ -d "${XDG_CONFIG_HOME}" ]] && mv --verbose "${XDG_CONFIG_HOME}" "${XDG_CONFIG_HOME}.bkp" || mkdir --parents "${XDG_CONFIG_HOME}.bkp"

# move all hidden files or directories (dotfiles) in `$HOME` to `$XDG_CONFIG_HOME.bkp`
find "${HOME}" -name '.*' | xargs mv --verbose --target-directory="${XDG_CONFIG_HOME}.bkp"

# clone repo and private submodule(s) into `$XDG_CONFIG_HOME`
sudo apt update && sudo apt install git-all --yes
user='delannoy'
private_identity_file='/path/to/identity_file'
# [How to specify the private SSH-key to use when executing shell command on Git?](https://stackoverflow.com/a/29754018/13019084)
export GIT_SSH_COMMAND="ssh -i ${private_identity_file} -o IdentitiesOnly=yes"
# [Using Git Submodules for Private Content](https://www.taniarascia.com/git-submodules-private-content/)
git clone --recurse-submodules "git@github.com:${user}/.config.git" "${XDG_CONFIG_HOME}"

# symlink startup files for login and interactive shells to their expected locations
ln --symbolic "${XDG_CONFIG_HOME}/bash/profile" "${HOME}/.bash_profile"
ln --symbolic "${XDG_CONFIG_HOME}/ssh" "${HOME}/.ssh"

# move contents of `${XDG_CONFIG_HOME}.bkp` back to `$XDG_CONFIG_HOME`
mv --verbose --interactive "${XDG_CONFIG_HOME}.bkp/"* "${XDG_CONFIG_HOME}/" && rmdir "${XDG_CONFIG_HOME}.bkp"
```

## tl;dr
```bash
backup_config(){
    export XDG_CONFIG_HOME="${HOME}/.config"
    local bkp_dir="${XDG_CONFIG_HOME}.bkp"
    [[ -d "${XDG_CONFIG_HOME}" ]] && mv --verbose "${XDG_CONFIG_HOME}" "${bkp_dir}" || mkdir --parents "${bkp_dir}"
    find "${HOME}" -name '.*' | xargs mv --verbose --target-directory="${bkp_dir}"
}

clone_config(){
    local user='delannoy'
    local private_identity_file='/path/to/identity_file'
    export GIT_SSH_COMMAND="ssh -i ${private_identity_file} -o IdentitiesOnly=yes"
    sudo apt update && sudo apt install git-all --yes
    git clone --recurse-submodules "https://github.com/${user}/.config.git" "${XDG_CONFIG_HOME}"
    ln -s "${XDG_CONFIG_HOME}/bash/profile" "${HOME}/.bash_profile"
    ln --symbolic "${XDG_CONFIG_HOME}/ssh" "${HOME}/.ssh"
    source "${HOME}/.bash_profile"
}

backup_config
clone_config
```

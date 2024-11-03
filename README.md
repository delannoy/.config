# XDG dotfiles

This repo aims to organize dotfiles into the `$XDG_CONFIG_HOME` directory, following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and simply version control said directory.
It relies heavily on information collected in the [ArchWiki XDG Base Directory page](https://wiki.archlinux.org/title/XDG_Base_Directory).
A private git submodule is used to version control private config files.

## Installation

```bash
# set `XDG_CONFIG_HOME` to its default location (`$HOME/.config`):
export XDG_CONFIG_HOME="${HOME}/.config"

# if it already exists, rename `$XDG_CONFIG_HOME` directory to `$XDG_CONFIG_HOME_bkp`; otherwise, create the backup directory:
[[ -d "${XDG_CONFIG_HOME}" ]] && mv --verbose "${XDG_CONFIG_HOME}" "${XDG_CONFIG_HOME}_bkp" || mkdir --parents --verbose "${XDG_CONFIG_HOME}_bkp"

# move all hidden files and directories (dotfiles) in `$HOME` to `$XDG_CONFIG_HOME_bkp` (except `.cache` and `.local` directories):
for i in "${HOME}/"[.]*; do [[ ! "${i##*/}" =~ .cache|.local ]] && mv --verbose --target-directory="${XDG_CONFIG_HOME}_bkp" "${i}"; done

# clone repo and private submodule(s) into `$XDG_CONFIG_HOME`:
sudo apt update && sudo apt install git-all --yes
github_user="${USER}"
private_identity_file='/path/to/identity_file'
export GIT_SSH_COMMAND="ssh -o IdentityFile=${private_identity_file} -o IdentitiesOnly=yes" # [How to specify the private SSH-key to use when executing shell command on Git?](https://stackoverflow.com/a/29754018/13019084)
git clone --recurse-submodules "git@github.com:${github_user}/.config.git" "${XDG_CONFIG_HOME}" # [Using Git Submodules for Private Content](https://www.taniarascia.com/git-submodules-private-content/)

# symlink startup files for login and interactive shells to their expected locations:
ln --symbolic "${XDG_CONFIG_HOME}/bash/profile" "${HOME}/.bash_profile"
ln --symbolic "${XDG_CONFIG_HOME}/ssh" "${HOME}/.ssh"

# move contents of `${XDG_CONFIG_HOME}_bkp` back to `$XDG_CONFIG_HOME`:
mv --verbose --interactive "${XDG_CONFIG_HOME}_bkp/"* "${XDG_CONFIG_HOME}/" && rmdir "${XDG_CONFIG_HOME}_bkp"
```

## tl;dr

```bash
function backup_config(){
    export XDG_CONFIG_HOME="${HOME}/.config";
    local bkp_dir="${XDG_CONFIG_HOME}_bkp";
    [[ -d "${XDG_CONFIG_HOME}" ]] && mv --verbose "${XDG_CONFIG_HOME}" "${bkp_dir}" || mkdir --parents --verbose "${bkp_dir}";
    for i in "${HOME}/"[.]*; do
        [[ ! "${i##*/}" =~ .cache|.local ]] && mv --verbose --target-directory="${bkp_dir}" "${i}";
    done
}

function clone_config(){
    local github_user="$1";
    local private_identity_file="$2";
    export GIT_SSH_COMMAND="ssh -o IdentityFile=${private_identity_file} -o IdentitiesOnly=yes"; # [How to specify the private SSH-key to use when executing shell command on Git?](https://stackoverflow.com/a/29754018/13019084)
    sudo apt update && sudo apt install git-all --yes;
    git clone --recurse-submodules "git@github.com:${github_user}/.config.git" "${XDG_CONFIG_HOME}"; # [Using Git Submodules for Private Content](https://www.taniarascia.com/git-submodules-private-content/)
    ln --symbolic "${XDG_CONFIG_HOME}/bash/profile" "${HOME}/.bash_profile";
    ln --symbolic "${XDG_CONFIG_HOME}/ssh" "${HOME}/.ssh";
    source "${HOME}/.bash_profile";
}

backup_config
clone_config "${USER}" '/path/to/identity_file'
mv --verbose --interactive "${XDG_CONFIG_HOME}_bkp/"* "${XDG_CONFIG_HOME}/" && rmdir "${XDG_CONFIG_HOME}_bkp"
```

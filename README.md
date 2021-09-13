```bash
export XDG_CONFIG_HOME="${HOME}/.config"
mkdir --parents "${XDG_CONFIG_HOME}" && cd "${XDG_CONFIG_HOME}"

# [How do I clone into a non-empty directory?](https://stackoverflow.com/a/18999726/13019084)
# [How to clone a git repo to an existing folder (not empty)](https://gist.github.com/ZeroDragon/6707408#gistcomment-3235804)
git init
git remote add origin 'git@github.com:delannoy/.config.git'
git fetch
git checkout --track origin/main -b main # [Specifying -b causes a new branch to be created as if git-branch[1] were called and then checked out.](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutem-b-Bltnewbranchgtltstartpointgt)
# git checkout --track origin/main # [When creating a new branch, set up "upstream" configuration. If no -b option is given, the name of the new branch will be derived from the remote-tracking branch](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt---track)
# git checkout --track origin/main -B main # [If -B is given, <new_branch> is created if it doesn't exist; otherwise, it is reset](https://git-scm.com/docs/git-checkout#Documentation/git-checkout.txt-emgitcheckoutem-b-Bltnewbranchgtltstartpointgt)

[[ "$(grep --count '${HOME}/.config/bash/profile' "${HOME}/.profile" 2>/dev/null)" != 1 ]] && echo 'source "${HOME}/.config/bash/profile"' >> "${HOME}/.profile"
[[ "$(grep --count '${HOME}/.config/bash/bashrc' "${HOME}/.bashrc" 2>/dev/null)" != 1 ]] && echo 'source "${HOME}/.config/bash/bashrc"' >> "${HOME}/.bashrc"
```
